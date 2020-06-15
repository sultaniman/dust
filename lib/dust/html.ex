defmodule Dust.HTML do
  @moduledoc false
  alias Dust.Asset
  alias Dust.HTML.{Format, Inline}

  @spec inline(String.t(), list(Asset.t()) | keyword()) :: list(String.t())
  def inline(content, assets) do
    content
    |> Format.split()
    |> Inline.inline(assets[:image], "</html>")
  end
end
