defmodule Dust.HTML.Scripts do
  alias Dust.Resource
  alias Dust.HTML.Format

  @type scripts() :: list(binary())
  @type resources() :: list(Resource.t())

  @spec inline(list(Resource.t()) | keyword()) :: scripts()
  def inline(resources) do
    resources
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

        %{result: {:error, _result, _state}} = resource ->
          ["<!--", "Unable to load script:", resource.relative_url, "-->"]
      end
    end)
  end
end
