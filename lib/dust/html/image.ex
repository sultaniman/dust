defmodule Dust.HTML.Image do
  @moduledoc """
  Module to encode images to Base64 data.
  """
  alias ExImageInfo, as: ExImage
  alias Dust.Dom

  @doc """
  Identify image mime and Base64 encode it's `content`.
  If it fails to identify format then we try to guess
  if it is SVG image otherwise placeholder of error image
  will be returned.
  """
  @spec encode(String.t(), binary()) :: binary()
  def encode(filename, content) do
    case ExImage.type(content) do
      {mime, _variant} ->
        "data:#{mime};base64,#{Base.encode64(content)}"

      _ ->
        maybe_svg(filename, content)
    end
  end

  defp maybe_svg(filename, content) do
    parsed = URI.parse(filename)

    is_svg =
      String.ends_with?(parsed.path, ".svg") ||
      String.starts_with?(content, "<?xml") ||
      String.contains?(content, "</svg>")

    if is_svg do
      "data:image/svg+xml;base64,#{Base.encode64(content)}"
    else
      Dom.error_image()
    end
  end
end
