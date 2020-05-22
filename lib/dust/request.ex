defmodule Dust.Request do
  @moduledoc false
  alias Dust.Request.{
    Client,
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
  @spec fetch(url(), options()) :: {Client.t(), Result.t()}
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
    client = %Client{
      opts: config,
      headers: headers
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
end
