defmodule Dust.HTML.Styles do
  alias Dust.Asset
  alias Dust.HTML.{Format, Inline}

  @type styles() :: list(binary())

  @task_max_wait_ms 5_000

  @spec inline(list(Asset.t()) | keyword()) :: styles()
  def inline(assets) do
    images = Keyword.get(assets, :image, [])
    wait_ms = length(images) * @task_max_wait_ms

    assets
    |> Keyword.get(:css, [])
    |> Enum.map(&async_inline(&1, images))
    |> Enum.map(&Task.await(&1, wait_ms))
  end

  defp async_inline(css, images) do
    Task.async(fn ->
      case css do
        %{result: {:ok, result, _state}} ->
          [
            "<style>",
            result.content
            |> Format.split()
            |> Inline.inline(images),
            "</style>"
          ]

        %{result: {:error, _result, _state}} = asset ->
          ["<!--", "Unable to load style:", asset.relative_url, "-->"]
      end
    end)
  end
end
