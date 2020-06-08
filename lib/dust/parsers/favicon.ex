defmodule Dust.Parsers.Favicon do
  @moduledoc """
  Parse document and returl favicon url.
  """
  alias Dust.Dom
  alias Dust.Parsers

  @spec parse(Floki.html_tree() | Floki.html_tag()) :: list(String.t())
  def parse(document) do
    icon =
      document
      |> Dom.attr("link[rel=icon]", "href")

    alternate_icon =
      document
      |> Dom.attr("link[rel='alternate icon']", "href")

    mask_icon =
      document
      |> Dom.attr("link[rel=mask-icon]", "href")

    (icon ++ alternate_icon ++ mask_icon)
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
