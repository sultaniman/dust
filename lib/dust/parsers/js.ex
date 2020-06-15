defmodule Dust.Parsers.JS do
  @moduledoc """
  Parse document and returl all links/URIs to
  scripts with absolute urls.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: [String.t()]
  def parse(document) do
    scripts = [
      Dom.attr(document, "link[as=script]", "href"),
      Dom.attr(document, "script", "src")
    ]

    scripts
    |> List.flatten()
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
  end
end
