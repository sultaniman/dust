defmodule Dust.Loaders.CSS.Inliner do
  @moduledoc """
  This module works with CSS and provides
  API to inline all images as base64 encoded
  values, this however does not include fonts.
  """
  alias ExImageInfo, as: Image
  alias Dust.Parsers
  alias Dust.Requests
  alias Dust.Requests.ClientState

  @css_url_regex ~r/url\(['"]?(?<uri>.*?)['"]?\)/

  @type css_content() :: binary()

  @doc """
  Extract all `url(…)` values, fetch, base64 encode and inline.
  Fonts however are not included.
  """
  @spec inline(css_content(), ClientState.t()) :: binary()
  def inline(css_content, client) do
    base_url = Parsers.URI.get_base_url(client.full_url)

    inline_sources =
      @css_url_regex
      |> Regex.scan(css_content)
      |> Enum.map(&Enum.at(&1, 1))
      |> Enum.reject(&is_data_image?/1)
      |> Enum.reject(&is_font?/1)
      |> Enum.map(&{&1, Parsers.URI.expand(base_url, &1)})
      |> Enum.map(&fetch(&1, client.options))
      |> Enum.map(&Task.await/1)

    Enum.reduce(inline_sources, css_content, fn source, replaced ->
      replace(source, replaced)
    end)
  end

  defp fetch({relative_url, absolute_url}, options) do
    Task.async(fn ->
      {relative_url, Requests.get(absolute_url, options)}
    end)
  end

  defp replace({url, {:ok, result, _client}}, inline_to) do
    cond do
      String.ends_with?(url, ".svg") ->
        String.replace(
          inline_to,
          url,
          "data:image/svg+xml;base64,#{Base.encode64(result.content)}"
        )

      true ->
        String.replace(
          inline_to,
          url,
          encode(result.content)
        )
    end
  end

  defp replace({_url, {:error, _result, _client}}, inline_to) do
    inline_to
  end

  defp encode(asset) do
    {mime, _variant} = Image.type(asset)
    "data:#{mime};base64,#{Base.encode64(asset)}"
  end

  defp is_data_image?(url) do
    String.starts_with?(url, "data:image")
  end

  defp is_font?(url) do
    (
      String.ends_with?(url, "ttf") ||
      String.ends_with?(url, "woff") ||
      String.ends_with?(url, "woff2") ||
      String.ends_with?(url, "otf") ||
      String.ends_with?(url, "eot") ||
      String.ends_with?(url, "ttc")
    )
  end
end
