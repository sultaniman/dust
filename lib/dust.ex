defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  alias Dust.{Fetcher, Parsers, Requests}
  alias Dust.HTML.{Format, Inline, Styles}

  def get(url, options \\ [])

  def get(url, options) do
    {:ok, result, state} = Requests.get(url, options)
    options = [
      headers: state.headers,
      proxy: state.proxy,
      options: state.proxy
    ]

    assets =
      result.content
      |> Parsers.parse()
      |> Fetcher.fetch(result.base_url, options)
      |> Fetcher.CSS.fetch(state)

    result.content
    |> Format.split()
    |> Inline.inline(assets[:image])

    Styles.inline(assets)
    # {result, assets}
    # :ok
  end

  def process() do
    proxy_uri = System.get_env("PROXY")
    Dust.get("https://github.com", proxy: proxy_uri)

    # {total, avg, improvement} = Fetcher.total_duration(results)
    # IO.puts("Total: #{total}, Avg: #{avg}, How fast: #{improvement} times")
  end

  def persist(path, contents) do
    with {:ok, file} <- File.open(path, [:write]) do
      IO.binwrite(file, contents)
      File.close(file)
    end
  end
end
