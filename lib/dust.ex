defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  alias Dust.{Requests, Parsers, Fetcher}

  def get(url, options \\ [])

  def get(url, options) do
    # {:ok, result, client_state} = Requests.get(url, options)
    Requests.get(url, options)
    # Loaders.process(result, [], client: client_state)
  end

  def process() do
    proxy_uri = System.get_env("SOCKS_PROXY")
    {:ok, result, state} = Dust.get("https://turannews.info", proxy: proxy_uri)
    assets = Parsers.parse(result.content)

    results = Fetcher.fetch(assets, result.base_url,
      headers: state.headers,
      proxy: state.proxy,
      options: state.proxy
    )
    {total, avg, improvement} = Fetcher.total_duration(results)
    IO.puts("Total: #{total}, Avg: #{avg}, How fast: #{improvement} times")

    # For each resources[:css] -> extract urls -> Fetcher.fetch() -> Append to resources[:css]
  end

  def persist(path, contents) do
    with {:ok, file} <- File.open(path, [:write]) do
      IO.binwrite(file, contents)
      File.close(file)
    end
  end
end
