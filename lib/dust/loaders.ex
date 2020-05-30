defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.{CSS, JS}
  alias Dust.Parsers

  @loaders [css: CSS, js: JS]

  def process(result, loaders \\ [], options \\ [])
  def process(result, loaders, options) do
    loaders
    |> get_loaders()
    |> Enum.map(&stack(&1, result, options))
  end

  defp stack(loader, result, options) do
    client_state = Keyword.get(options, :client_state, [])
    result
    |> loader.extract()
    |> loader.load(client: client_state, base_url: result.original_request.url)
    # |> loader.inject()
  end

  defp get_loaders([]), do: Keyword.values(@loaders)
  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k) end)
  end
end
