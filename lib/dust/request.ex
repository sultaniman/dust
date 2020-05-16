defmodule Dust.Request do
  @moduledoc false
  alias Dust.Result
  alias Dust.Request.{Proxy, Util}

  @type url() :: String.t()
  @type options() :: Keyword.t() | any()

  @spec fetch(url(), options()) :: Result.t()
  def fetch(url, options) do
    headers = Keyword.get(options, :headers, %{})
    proxy = Keyword.get(options, :proxy)
    if proxy do
      get(url, headers, Proxy.get_config(proxy))
    else
      get(url, headers, [])
    end
  end

  defp get(url, headers, config) do
    start_ms = System.monotonic_time(:millisecond)

    case HTTPoison.get(url, headers, config) do
      {:ok, %HTTPoison.Response{status_code: status, body: body, headers: response_headers}} ->
        %Result{
          content: body,
          status: status,
          duration: Util.duration(start_ms),
          headers: response_headers
        }

      {:error, %HTTPoison.Error{reason: reason}} ->
        %Result{
          content: reason,
          status: 0,
          duration: Util.duration(start_ms),
          headers: nil,
        }
    end
  end

end
