defmodule Dust.Loaders.Image do
  @moduledoc """
  Embed with mime `data:image/<MIME>;base64,BASE64` for binary formats
  for svg `data:image/svg+xml,URI_ENCODED_SVG`
  Ignore already embedded `data:image`
  """
  def extract(result) do
    []
  end

  def load(links, options) do
    []
  end

  def template(results) do
    {:image, []}
  end
end
