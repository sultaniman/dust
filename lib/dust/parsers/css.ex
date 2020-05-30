defmodule Dust.Parsers.CSS do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    links =
      document
      |> find("link[rel=stylesheet]", "href")

    links_preloaded =
      document
      |> find("link[as=style]", "href")

    styles =
      document
      |> find("style", "src")

    links ++ links_preloaded ++ styles
    |> MapSet.new()
    |> MapSet.to_list()
  end

  defp find(document, selector, attr) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attr)
  end
end
