defmodule Dust.Loaders.CSS do
  @moduledoc """
  CSS loader is responsible to

    1. fetch all CSS assets,
    2. Extract and resolve all images,
    3. Inline images as base64 encoded values
  """
  alias Dust.Requests
  alias Dust.Parsers
  alias Dust.Loaders.CSS.Inliner

  @type url() :: String.t()
  @type links() :: list(url())
  @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
  @type result_list() :: list({url(), result()})

  @spec extract(Result.t()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.css(document, result.original_request)
    end
  end

  @doc """
  Fetch all CSS files and return contents as the list
  of tuples `result_list`

  ```elixir
  {url, {:ok, Result.t()} | {:error, Result.t()}}
  ```

  In the options we expect `:base_url` which is used to
  resolve absolute path to CSS file.

  ## Usage

  ```elixir
  CSS.load([url, ..., urlN], base_url: "https://bobo.com")
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

  @spec template(result_list()) :: {:css, list(String.t())}
  def template(results) do
    {:css, Enum.map(results, &render/1)}
  end

  defp render({style_url, {:ok, style_result, client}}) do
    content = Inliner.inline(style_result.content, client)
    """
    <style>
    /*Style source: #{style_url}*/
    #{content}
    </style>
    """
  end

  defp render({style_url, {:error, style_result, _}}) do
    """
    <!--Failed to load: #{style_url}, reason: #{inspect(style_result.error)}-->
    """
  end

  ## Private
  defp fetch(url, options) do
    Task.async(fn ->
      {url, Requests.get(url, options)}
    end)
  end
end
