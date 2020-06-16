defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  alias Dust.Requests.Result
  alias Dust.{Fetcher, HTML, Parsers, Requests}

  @doc """
  Fetch given url with scripts, stylesheets and image assets
  """
  @spec get(String.t(), Keyword.t()) :: Result.t()
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

    %Result{
      result
      | full_content: [
          HTML.inline(result.content, assets),
          HTML.Styles.inline(assets),
          HTML.Scripts.inline(assets),
          "</html>"
        ],
        assets: assets
    }
  end

  def process() do
    proxy_uri = System.get_env("PROXY")
    Dust.get("https://github.com", proxy: proxy_uri)

    # {total, avg, improvement} = Fetcher.total_duration(results)
    # IO.puts("Total: #{total}, Avg: #{avg}, How fast: #{improvement} times")
  end

  def persist(contents, path) when is_list(contents) do
    with {:ok, file} <- File.open(path, [:write]) do
      IO.binwrite(file, contents)
      File.close(file)
    end
  end
  def persist(%Requests.Result{} = result, path) do
    persist(result.full_content, path)
  end
end
