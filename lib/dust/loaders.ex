defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.{CSS, JS}
  alias Dust.Parsers

  @loaders [css: CSS, js: JS]

  def process(result, loaders \\ [], options \\ [])
  def process(result, loaders, options) do
    loaders = get_loaders(loaders)
    client_state = Keyword.get(options, :client_state, [])
    loaders
    |> Enum.map(&stack(&1, result))
  end

  defp stack(loader, result) do
    result
    |> loader.extract()
    # |> loader.load()
    # |> loader.inject()
  end

  defp get_loaders([]), do: Keyword.values(@loaders)
  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k) end)
  end
end
