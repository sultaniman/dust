defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.CSS

  @loaders [css: CSS]

  def load(result, options \\ [], loaders \\ [])
  def load(result, _options, loaders) do
    loaders = get_loaders(loaders)
    {loaders, result}
  end

  defp get_loaders([]), do: Keyword.values(@loaders)
  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k)end)
    |> Enum.map(fn {_k, v} -> v end)
  end
end
