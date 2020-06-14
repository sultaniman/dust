defmodule Dust.List do
  @spec merge(list(), list()) :: list()
  def merge(first, second) do
    yield = fn item, acc -> [item | acc] end

    first
    |> Enum.reverse()
    |> Enum.reduce(second, yield)
  end
end
