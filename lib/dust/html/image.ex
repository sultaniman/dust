defmodule Dust.HTML.Image do
  alias ExImageInfo, as: ExImage
  alias Dust.Dom

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

    if String.ends_with?(parsed.path, ".svg") do
      "data:image/svg+xml;base64,#{Base.encode64(content)}"
    else
      Dom.error_image()
    end
  end
end
