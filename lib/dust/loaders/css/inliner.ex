defmodule Dust.Loaders.CSS.Inliner do
  @moduledoc false
  alias ExImageInfo, as: Image
  alias Dust.Parsers
  alias Dust.Requests

  @css_url_regex ~r/url\(['"]?(?<uri>.*?)['"]?\)/
  @tag "data:image"

  def inline(css_content, client) do
    base_url = Parsers.URI.get_base_url(client.full_url)

    inline_sources =
      @css_url_regex
      |> Regex.scan(css_content)
      |> Enum.map(&Enum.at(&1, 1))
      |> Enum.reject(&String.starts_with?(&1, @tag))
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
      is_font?(url) ->
        inline_to

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
