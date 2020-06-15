defmodule Dust.HTML.Inline do
  alias Dust.Resource
  alias Dust.HTML.Image

  @type content_list() :: list(binary())
  @type resources() :: list(Resource.t())

  @spec inline(content_list(), resources(), String.t() | nil) :: content_list()
  def inline(lines, resources, drop_string \\ nil)
  def inline(lines, resources, drop_string) do
    Enum.map(lines, fn line ->
      resources
      |> Enum.reduce(line, &replace_image/2)
      |> maybe_drop_substring(drop_string)
    end)
  end

  defp maybe_drop_substring(line, nil), do: line
  defp maybe_drop_substring(line, drop) do
    if drop == "" do
      line
    else
      String.replace(line, drop, "")
    end
  end

  defp replace_image(nil, line), do: line
  defp replace_image([], line), do: line
  defp replace_image(%{result: {:error, _result, _}}, line), do: line
  defp replace_image(%{result: {:ok, result, _}} = resource, line) do
    if String.contains?(line, resource.relative_url) do
      String.replace(
        line,
        resource.relative_url,
        Image.encode(resource.relative_url, result.content)
      )
    else
      line
    end
  end
end
