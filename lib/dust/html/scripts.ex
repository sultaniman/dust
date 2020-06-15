defmodule Dust.HTML.Scripts do
  alias Dust.Asset
  alias Dust.HTML.Format

  @type scripts() :: list(binary())

  @spec inline(list(Asset.t()) | keyword()) :: scripts()
  def inline(assets) do
    assets
    |> Keyword.get(:js, [])
    |> Enum.map(&async_inline/1)
    |> Enum.map(&Task.await/1)
  end

  defp async_inline(js) do
    Task.async(fn ->
      case js do
        %{result: {:ok, result, _state}} ->
          [
            "<script lang=\"javascript\">",
            Format.split(result.content),
            "</script>"
          ]

        %{result: {:error, _result, _state}} = asset ->
          ["<!--", "Unable to load script:", asset.relative_url, "-->"]
      end
    end)
  end
end