defmodule Dust.Parsers.Image do
  @moduledoc """
  Parse document and returl all links/URIs to
  scripts with absolute urls.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    imgs = Dom.attr(document, "img", "src")
    pictures = Dom.attr(document, "picture > source", "srcset")

    imgs ++ pictures
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
