defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.CSS

  @loaders [css: CSS]

  def load(result, loaders \\ [], options \\ [])
  def load(result, loaders, options) do
    loaders = get_loaders(loaders)
    client_state = Keyword.get(options, :client_state, [])

    # |> extract()
    # |> fetch()
    # |> inject()
    {loaders, result}
  end

  defp extract(loader, result) do
  end

  defp inject(loader, result) do
  end

  defp get_loaders([]), do: Keyword.values(@loaders)
  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k) end)
  end
end
