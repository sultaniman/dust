defmodule Dust.Requests do
  @moduledoc """
  Requests provide an API to make fetch pages also it supports
  automatic retries with constant backoff the request should fail.
  """
  use Retry

  alias Dust.Parsers

  alias Dust.Requests.{
    State,
    Proxy,
    Result,
    Util
  }

  @type url() :: String.t()
  @type options() :: Keyword.t() | any()
  @type result() :: {:ok, Result.t(), State.t()} | {:error, Result.t(), State.t()}

  @max_redirects 3
  @max_retries 3
  @wait_ms 100

  @doc """
  ## Arguments

    1. `url` - url to page,
    2. `options` - keyword list with options

  Supports the following options

    1. :proxy - Proxy | string
    2. :headers - map | keyword list
    3. :max_retries - int,
    4. :max_redirects - int,
    5. :follow_redirect - boolean

  ## Usage

    ```elixir
    iex> Dust.Requests.get(<URL>, proxy: "socks5://user:pass@10.10.10.10:1080", max_retries: 8,)
    ```
  """
  @spec get(url(), options()) :: result()
  def get(url, options \\ []) do
    {max_retries, options} = Keyword.pop(options, :max_retries, @max_retries)
    {headers, options} = Keyword.pop(options, :headers, [])
    {proxy_config, options} = Keyword.pop(options, :proxy, nil)

    proxy =
      proxy_config
      |> Util.get_proxy()
      |> Proxy.get_config()

    retry with: constant_backoff(@wait_ms) |> Stream.take(max_retries) do
      fetch(url, headers, proxy, get_options(options))
    after
      result -> result
    else
      error -> error
    end
  end

  ## Private helpers
  defp fetch(url, headers, proxy, options) do
    start_ms = System.monotonic_time(:millisecond)
    client = State.new(url, headers, proxy, options)

    {status, result} =
      url
      |> Parsers.URI.normalize()
      |> HTTPoison.get(headers, options)
      |> Result.from_request(Util.duration(start_ms))

    {status, result, client}
  end

  defp get_options(options) do
    {max_redirects, options} = Keyword.pop(options, :max_redirects, @max_redirects)
    {follow_redirect, options} = Keyword.pop(options, :follow_redirect, true)

    base_options = [
      max_redirects: max_redirects,
      follow_redirect: follow_redirect
    ]

    base_options
    |> Keyword.merge(options)
  end
end
