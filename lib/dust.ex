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
    proxy_uri = System.get_env("PROXY")
    {:ok, result, state} = Dust.get("https://github.com", proxy: proxy_uri)
    assets = Parsers.parse(result.content)

    results = Fetcher.fetch(assets, result.base_url,
      headers: state.headers,
      proxy: state.proxy,
      options: state.proxy
    )

    css_assets =
      results
      |> Keyword.get(:css, [])
      |> Enum.map(&collect_css_urls/1)
      |> bin_results()
      |> Enum.map(&fetch_bin(&1, state))
      |> remap_results()
      |> Dust.List.merge(results[:image])

    Keyword.put(results, :image, css_assets)
    # {total, avg, improvement} = Fetcher.total_duration(results)
    # IO.puts("Total: #{total}, Avg: #{avg}, How fast: #{improvement} times")
    # For each resources[:css] -> extract urls -> Fetcher.fetch() -> Append to resources[:image]
  end

  defp collect_css_urls(%{result: {:error, _, _state}}) do
    []
  end
  defp collect_css_urls(%{result: {:ok, result, _state}}) do
    base_url = Parsers.URI.get_base_url(result.base_url, false)
    result.content
    |> Parsers.URI.parse()
    |> Enum.map(&{base_url, &1})
  end

  defp bin_results(results) do
    results
    |> List.flatten()
    |> Enum.reduce(%{}, fn {key_url, url}, acc ->
      if Map.has_key?(acc, key_url) do
        Map.replace!(acc, key_url, [url | acc[key_url]])
      else
        Map.put_new(acc, key_url, [url])
      end
    end)
  end

  defp fetch_bin({base_url, urls}, state) do
    Fetcher.fetch([image: urls], base_url,
      headers: state.headers,
      proxy: state.proxy,
      options: state.proxy
    )
  end

  defp remap_results(results) do
    results
    |> List.flatten()
    |> Enum.map(fn {_, css_results} -> css_results end)
    |> List.flatten()
  end

  def persist(path, contents) do
    with {:ok, file} <- File.open(path, [:write]) do
      IO.binwrite(file, contents)
      File.close(file)
    end
  end
end
