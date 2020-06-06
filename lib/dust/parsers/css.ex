defmodule Dust.Parsers.CSS do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    links =
      document
      |> Dom.attr("link[rel=stylesheet]", "href")

    links_preloaded =
      document
      |> Dom.attr("link[as=style]", "href")

    styles =
      document
      |> Dom.attr("style", "src")

    (links ++ links_preloaded ++ styles)
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
