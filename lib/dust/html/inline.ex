defmodule Dust.HTML.Inline do
  @moduledoc """
  Inlines image assets into given content
  which is the list of lines.
  """
  alias Dust.Asset
  alias Dust.HTML.Image

  @type content_list() :: list(String.t())
  @type assets() :: list(Asset.t())

  @doc """
  Search each line and inline `assets` which represent images

  Parameters:

  * `lines` list of strings of raw HTML,
  * `assets` collection of images,
  * `drop_string` optional parameter which is a string
    which you may want to drop from original content.

  Returns:

    * `[String.t()]` HTML content with Base64 encoded and embedded images.
  """

  @spec inline(content_list(), assets(), String.t() | nil) :: content_list()

  def inline(lines, assets, drop_string \\ nil)

  def inline(lines, assets, drop_string) do
    Enum.map(lines, fn line ->
      assets
      |> Enum.reduce(line, &replace_image/2)
      |> maybe_drop_substring(drop_string)
    end)
  end

  defp maybe_drop_substring(line, nil), do: line

  defp maybe_drop_substring(line, drop) do
    if drop == "" do
      line
    else
      String.replace(line, drop, "")
    end
  end

  defp replace_image(nil, line), do: line
  defp replace_image([], line), do: line
  defp replace_image(%{result: {:error, _result, _}}, line), do: line

  defp replace_image(%{result: {:ok, result, _}} = asset, line) do
    if String.contains?(line, asset.relative_url) do
      String.replace(
        line,
        asset.relative_url,
        Image.encode(asset.relative_url, result.content)
      )
    else
      line
    end
  end
end
