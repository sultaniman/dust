defmodule Dust.Parsers.JS do
  @moduledoc """
  Parse document and returl all links/URIs to
  scripts with absolute urls.
  """
  alias Dust.Dom

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    scripts_preloaded = Dom.attr(document, "link[as=script]", "href")
    scripts = Dom.attr(document, "script", "src")

    (scripts_preloaded ++ scripts)
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
