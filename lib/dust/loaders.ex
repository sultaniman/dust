defmodule Dust.Loaders do
  @moduledoc false
  alias Dust.Loaders.{CSS, Image, JS}
  alias Dust.{Parsers, Requests}

  @type url() :: String.t()
  @type links() :: list(url())
  @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
  @type result_list() :: list({url(), result()})

  @loaders [css: CSS, image: Image, js: JS]

  def process(result, loaders \\ [], options \\ [])

  def process(result, loaders, options) do
    assets =
      loaders
      |> get_loaders()
      |> Enum.map(&stack(&1, result, options))

    full_content =
      Enum.reduce(assets, result.content, fn {name, assets}, page ->
        loader = Keyword.get(@loaders, name)
        loader.inline(assets, page)
      end)

    %{result | full_content: full_content, assets: assets}
  end

  @doc """
  Fetch all given assets and return contents as the list
  of tuples `result_list`

  ```elixir
  {url, {:ok, Result.t()} | {:error, Result.t()}}
  ```

  In the options we expect `:base_url` which is used to
  resolve absolute path to CSS/JS/SVG... files.

  ## Usage

  ```elixir
  Loaders.load([url, ..., urlN], base_url: "https://bobo.com")
  ```
  """
  @spec load(links(), keyword()) :: result_list()
  def load(links, options) do
    base_url = Keyword.get(options, :base_url)

    links
    |> Enum.map(&Parsers.URI.expand(base_url, &1))
    |> Enum.map(&fetch(&1, options))
    |> Enum.map(&Task.await/1)
  end

  defp stack(loader, result, options) do
    {client_state, _options} = Keyword.pop(options, :client_state, [])

    options = [
      client: client_state,
      base_url: result.original_request.url
    ]

    {
      loader.tag,
      result
      |> loader.extract()
      |> load(options)
    }
  end

  defp fetch(url, options) do
    Task.async(fn ->
      {url, Requests.get(url, options)}
    end)
  end

  defp get_loaders([]), do: Keyword.values(@loaders)

  defp get_loaders(loaders) do
    loaders
    |> Enum.filter(fn {k, _v} -> Keyword.has_key?(@loaders, k) end)
  end
end
