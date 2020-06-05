defmodule Dust.Loaders.Image.Inliner do
  @moduledoc """
  This module works with images and provides
  API to inline all images as base64 encoded.
  """
  alias ExImageInfo, as: Image

  @type raw_document() :: String.t()
  @type url() :: String.t()
  @type images() :: list({url(), binary()})

  @doc """
  Extract all `url(…)` values, fetch, base64 encode and inline.
  Fonts however are not included.
  """
  @spec inline(raw_document(), images()) :: binary()
  def inline(document, images) do
    # Enum.reduce(inline_sources, css_content, fn source, replaced ->
    #   replace(source, replaced)
    # end)
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
end
