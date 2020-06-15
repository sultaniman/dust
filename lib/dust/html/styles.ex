defmodule Dust.HTML.Styles do
  alias Dust.Resource
  alias Dust.HTML.{Format, Inline}

  @type styles() :: list(binary())
  @type resources() :: list(Resource.t())

  @task_max_wait_ms 5_000

  @spec inline(list(Resource.t()) | keyword()) :: styles()
  def inline(resources) do
    images = Keyword.get(resources, :image, [])
    wait_ms = length(images) * @task_max_wait_ms

    resources
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

        %{result: {:error, _result, _state}} = resource ->
          ["<!--", "Unable to load style:", resource.relative_url, "-->"]
      end
    end)
  end
end
