defmodule Dust.Parsers.Favicon do
  @moduledoc """
  Parse document and returl favicon url.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @doc """
  Extract all links to favicon

  Following selectors are used:

    * `link[rel=icon]`
    * `link[rel='alternate icon']`
    * `link[rel=mask-icon]`
  """
  @spec parse(Floki.html_tree() | Floki.html_tag()) :: [String.t()]
  def parse(document) do
    icons = [
      Dom.attr(document, "link[rel=icon]", "href"),
      Dom.attr(document, "link[rel='alternate icon']", "href"),
      Dom.attr(document, "link[rel=mask-icon]", "href")
    ]

    icons
    |> List.flatten()
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
  end
end
