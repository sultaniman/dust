defmodule Dust.HTML.Inline do
  alias Dust.Resource
  alias Dust.HTML.Image

  @type content_list() :: list(binary())
  @type resources() :: list(Resource.t())

  @spec inline(content_list(), resources()) :: content_list()
  def inline(content, resources) do
    content
    |> Enum.map(fn line ->
      resource =
        resources
        |> Enum.filter(&String.contains?(line, &1.relative_url))
        |> List.first()

      case resource do
        [] -> line
        nil -> line
        _ ->
          IO.inspect(resource)
          %{result: {:ok, result, _}} = resource
          String.replace(
            line,
            resource.relative_url,
            Image.encode(resource.relative_url, result.content)
          )
      end
    end)
  end
end
