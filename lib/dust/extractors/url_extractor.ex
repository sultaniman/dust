defmodule Dust.Extractors.UrlExtractor do
  @moduledoc """
  Parse document and returl all links/URIs to
  scripts with absolute urls.
  """
  alias Dust.Parsers
  @css_url_regex ~r/url\(['"]?(?<uri>.*?)['"]?\)/

  @spec extract(String.t()) :: list(String.t())
  def extract(content) do
    @css_url_regex
    |> Regex.scan(content)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.reject(&Parsers.URI.is_empty?/1)
    |> Enum.reject(&Parsers.URI.is_data_url?/1)
    |> Enum.reject(&Parsers.URI.is_font?/1)
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
