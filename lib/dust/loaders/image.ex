defmodule Dust.Loaders.Image do
  @moduledoc """
  Embed with mime `data:image/<MIME>;base64,BASE64` for binary formats
  for svg `data:image/svg+xml,URI_ENCODED_SVG`
  Ignore already embedded `data:image`
  """
  alias Dust.Parsers

  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.image(document)
    end
  end
end
