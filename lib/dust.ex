defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  alias Dust.{Requests, Parsers, Fetcher}

  def get(url, options \\ [])

  def get(url, options) do
    {:ok, result, state} = Requests.get(url, options)
    options = [
      headers: state.headers,
      proxy: state.proxy,
      options: state.proxy
    ]

    result.content
    |> Parsers.parse()
    |> Fetcher.fetch(result.base_url, options)
    |> Fetcher.CSS.fetch(state)
  end

  def process() do
    proxy_uri = System.get_env("PROXY")
    Dust.get("https://github.com", proxy: proxy_uri)

    # {total, avg, improvement} = Fetcher.total_duration(results)
    # IO.puts("Total: #{total}, Avg: #{avg}, How fast: #{improvement} times")
    # For each resources[:css] -> extract urls -> Fetcher.fetch() -> Append to resources[:image]
  end

  def persist(path, contents) do
    with {:ok, file} <- File.open(path, [:write]) do
      IO.binwrite(file, contents)
      File.close(file)
    end
  end
end
