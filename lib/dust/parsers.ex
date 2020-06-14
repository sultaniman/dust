defmodule Dust.Parsers do
  @moduledoc """
  Parsers API provides abstractions to
  get relevant assets from the DOM.
  """
  alias Dust.Parsers
  alias Dust.Parsers.{CSS, Image, JS}

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
  @spec parse(String.t()) :: keyword()
  def parse(document) do
    with {:ok, dom} <- Floki.parse_document(document) do
      [
        Task.async(fn -> {:css, css(dom)} end),
        Task.async(fn -> {:js, js(dom)} end),
        Task.async(fn ->
          {:image, Dust.List.merge(image(dom), parse_urls(document))}
        end)
      ]
      |> Enum.map(&Task.await(&1))
    end
  end

  @doc """
  Parses raw HTML document and extracts all CSS
  `url(...)` values directly embedded via `style` attribute.
  """
  @spec parse_urls(String.t()) :: list(String.t())
  def parse_urls(document) do
    Parsers.URI.parse(document)
  end

  @spec css(document()) :: sources()
  def css(document), do: CSS.parse(document)

  @spec js(document()) :: sources()
  def js(document), do: JS.parse(document)

  @spec image(document()) :: sources()
  def image(document), do: Image.parse(document)
end
