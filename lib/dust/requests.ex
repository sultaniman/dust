defmodule Dust.Requests do
  @moduledoc false
  use Retry

  alias Dust.Requests.{
    ClientState,
    Proxy,
    Result,
    Util
  }

  @type url() :: String.t()
  @type options() :: Keyword.t() | any()

  @max_retries 3
  @wait_ms 100
  def get(url, options \\ []) do
    {max_retries, options} = Keyword.pop(options, :max_retries, @max_retries)
    {headers, options} = Keyword.pop(options, :headers, [])

    retry with: constant_backoff(@wait_ms) |> Stream.take(max_retries) do
      fetch(url, headers, get_options(options))
    after
      result -> result
    else
      error -> error
    end
  end

  ## Private helpers
  defp fetch(url, headers, options) do
    start_ms = System.monotonic_time(:millisecond)
    client = ClientState.new(url, headers, options)

    {status, result} =
      url
      |> full_url()
      |> HTTPoison.get(headers, options)
      |> Result.from_request(Util.duration(start_ms))

    {status, result, client}
  end

  defp get_options(options) do
    {proxy_config, options} = Keyword.pop(options, :proxy, nil)

    proxy =
      proxy_config
      |> Util.get_proxy()
      |> Proxy.get_config()

    Keyword.merge(options, proxy)
  end

  def full_url(url) do
    with %{scheme: scheme, host: host, path: path} <- URI.parse(url) do
      "#{scheme || :https}://#{host || path}"
    end
  end
end
