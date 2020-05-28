defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.CSS

  @loaders [css: CSS]

  def process(result, loaders \\ [], options \\ [])
  def process(result, loaders, options) do
    loaders = get_loaders(loaders)
    client_state = Keyword.get(options, :client_state, [])

    loaders
    |> Enum.map(&extract(&1, result))
    |> Enum.map(&load(&1, result, client_state))
    # |> fetch()
    # |> inject()
    {loaders, result}
  end

  defp extract(loader, result) do
  end

  defp load(loader, result, client) do
  end

  defp inject(loader, result) do
  end

  defp get_loaders([]), do: Keyword.values(@loaders)
  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k) end)
  end
end
