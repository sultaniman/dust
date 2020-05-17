defmodule Dust.Request.Util do
  @moduledoc false
  @type domain() :: binary()
  @type uri() :: binary()

  @spec duration(non_neg_integer()) :: non_neg_integer()
  def duration(start_ms) do
    System.monotonic_time(:millisecond) - start_ms
  end

  @spec same_domain?(domain(), uri()) :: boolean()
  def same_domain?(domain, uri) do
    true
  end
end
