defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.{CSS, JS}

  @loaders [css: CSS, js: JS]

  def process(result, loaders \\ [], options \\ [])
  def process(result, loaders, options) do
    loaders = get_loaders(loaders)
    sources =
      loaders
      |> Enum.map(&stack(&1, result, options))

    assets =
      @loaders
      |> Keyword.keys()
      |> Enum.map(&Keyword.get(sources, &1, []))
      |> Enum.join("\n")

    full_content = String.replace(result.content, "</html>", "#{assets}</html>")
    %{result | full_content: full_content}
  end

  defp stack(loader, result, options) do
    client_state = Keyword.get(options, :client_state, [])
    result
    |> loader.extract()
    |> loader.load(client: client_state, base_url: result.original_request.url)
    |> loader.template()
  end

  defp get_loaders([]), do: Keyword.values(@loaders)
  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k) end)
  end
end
