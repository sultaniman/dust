defmodule Dust.Request do
  @moduledoc false
  alias Dust.Request.{
    ClientState,
    Proxy,
    Result,
    Util
  }

  @type url() :: String.t()
  @type options() :: Keyword.t() | any()

  @doc """
  Available options

  1. `:headers`,
  2. `:proxy`
  """
  @spec fetch(url(), options()) :: {ClientState.t(), Result.t()}
  def fetch(url, options) do
    headers = Keyword.get(options, :headers, %{})
    config =
      options
      |> Keyword.get(:proxy)
      |> Proxy.get_config()

    get(url, headers, config)
  end

  defp get(url, headers, config) do
    start_ms = System.monotonic_time(:millisecond)
    uri = URI.parse(url)
    client = %ClientState{
      opts: config,
      headers: headers,
      full_url: get_scheme(uri.scheme) <> uri.host
    }

    case HTTPoison.get(url, headers, config) do
      {:ok, %HTTPoison.Response{status_code: status, body: body, headers: response_headers}} ->
        {
          client,
          %Result{
            content: body,
            status: status,
            duration: Util.duration(start_ms),
            headers: response_headers
          }
        }

      {:error, %HTTPoison.Error{reason: reason}} ->
        {
          client,
          %Result{
            content: reason,
            status: 0,
            duration: Util.duration(start_ms),
            headers: nil,
          }
        }
    end
  end

  defp get_scheme(scheme) do
    if String.starts_with?(scheme, "http") do
      "#{scheme}://"
    else
      "http://"
    end
  end
end
