defmodule Dust.Parsers.CSS do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: [String.t()]
  def parse(document) do
    links = [
      Dom.attr(document, "link[rel=stylesheet]", "href"),
      Dom.attr(document, "link[as=style]", "href"),
      Dom.attr(document, "style", "src")
    ]

    links
    |> List.flatten()
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
  end
end
