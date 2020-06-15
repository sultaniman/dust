defmodule Dust.HTML do
  @moduledoc false
  alias Dust.Asset
  alias Dust.HTML.{Format, Inline}

  @doc """
  Search and inline `assets` which represent images

  Parameters:

  * `content` raw HTML,
  * `assets` collection of images.

  Returns:

    `list(String.t())` HTML content with Base64 encoded and embedded images.
  """

  @spec inline(String.t(), list(Asset.t()) | keyword()) :: list(String.t())
  def inline(content, assets) do
    content
    |> Format.split()
    |> Inline.inline(assets[:image], "</html>")
  end
end
