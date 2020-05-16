defmodule Dust.Request.Util do
  @moduledoc false
  @spec duration(non_neg_integer()) :: non_neg_integer()
  def duration(start_ms) do
    System.monotonic_time(:millisecond) - start_ms
  end
end
