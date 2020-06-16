defmodule Dust.Parsers do
  @moduledoc """
  Parsers API provides abstractions to
  get relevant assets from the DOM.
  """
  alias Dust.Parsers
  alias Dust.Parsers.{CSS, Image, Favicon, JS}

  @type sources() :: list(String.t())
  @type document() :: Floki.html_tag() | Floki.html_tree()

  @doc """
  Parses raw HTML document and extracts all links
  to CSS, JS and images for images it also extracts
  `url(...)` values directly embedded via `style` attribute.

  Returns:

    ```elixir
    [
      css: ["some/relative/url.css", "http://absolute.url/app.css"],
      js: ["some/relative/url.js", "http://absolute.url/app.js"],
      images: ["some/relative/url.jpg", "http://absolute.url.png"]
    ]
    ```
  """
  @spec parse(String.t()) :: list()
  def parse(document) do
    with {:ok, dom} <- Floki.parse_document(document) do
      [
        Task.async(fn -> {:css, css(dom)} end),
        Task.async(fn -> {:js, js(dom)} end),
        Task.async(fn ->
          {
            :image,
            dom
            |> favicon()
            |> Dust.List.merge(image(dom))
            |> Dust.List.merge(parse_urls(document))
          }
        end)
      ]
      |> Enum.map(&Task.await(&1))
    end
  end

  @doc """
  Parses raw HTML document and extracts CSS
  `url(...)` values directly embedded via `style` attribute.
  """
  @spec parse_urls(String.t()) :: sources()
  def parse_urls(document) do
    Parsers.URI.parse(document)
  end

  @doc """
  Parses raw HTML document and extracts CSS urls
  """
  @spec css(document()) :: sources()
  def css(document), do: CSS.parse(document)

  @doc """
  Parses raw HTML document and extracts JavaScript urls
  """
  @spec js(document()) :: sources()
  def js(document), do: JS.parse(document)

  @doc """
  Parses raw HTML document and extracts image urls
  """
  @spec image(document()) :: sources()
  def image(document), do: Image.parse(document)

  @doc """
  Parses raw HTML document and extracts favicon urls
  """
  @spec favicon(document()) :: sources()
  def favicon(document), do: Favicon.parse(document)
end
