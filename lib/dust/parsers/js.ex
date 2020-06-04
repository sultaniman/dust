defmodule Dust.Parsers.JS do
  @moduledoc """
  Parse document and returl all links/URIs to
  scripts with absolute urls.
  """
  alias Dust.Dom

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    scripts_preloaded =
      document
      |> Dom.attr("link[as=script]", "href")

    styles =
      document
      |> Dom.attr("script", "src")

    scripts_preloaded ++ styles
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
