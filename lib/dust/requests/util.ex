defmodule Dust.Requests.Util do
  @moduledoc false
  alias Dust.Requests.Proxy
  @type domain() :: binary()
  @type uri() :: binary()

  @spec duration(non_neg_integer()) :: non_neg_integer()
  def duration(start_ms) do
    System.monotonic_time(:millisecond) - start_ms
  end

  def get_proxy(proxy) when is_binary(proxy) do
    %Proxy{address: proxy}
  end

  def get_proxy(%Proxy{} = proxy) do
    proxy
  end
end
