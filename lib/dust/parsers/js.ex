defmodule Dust.Parsers.CSS do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    scripts_preloaded =
      document
      |> find("link[as=script]", "href")

    styles =
      document
      |> find("script", "src")

    scripts_preloaded ++ styles
    |> MapSet.new()
    |> MapSet.to_list()
  end

  defp find(document, selector, attr) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attr)
  end
end
