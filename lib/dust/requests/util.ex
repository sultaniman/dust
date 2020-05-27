defmodule Dust.Requests.Util do
  @moduledoc false
  alias Dust.Requests.Proxy
  @type domain() :: binary()
  @type uri() :: binary()

  @spec duration(non_neg_integer()) :: non_neg_integer()
  def duration(start_ms) do
    System.monotonic_time(:millisecond) - start_ms
  end

  def get_proxy(nil), do: nil
  def get_proxy(proxy) when is_binary(proxy) do
    if String.trim(proxy) == "" do
      nil
    else
      %Proxy{address: proxy}
    end
  end

  def get_proxy(%Proxy{} = proxy) do
    proxy
  end
end
