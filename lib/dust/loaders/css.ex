defmodule Dust.Loaders.CSS do
  @moduledoc false
  use Dust.Types
  alias Dust.Requests
  alias Dust.Parsers
  alias Dust.Loaders.CSS.Inliner

  # @spec extract(Result.t()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.css(document, result.original_request)
    end
  end

  def load(links, options) do
    base_url = Keyword.get(options, :base_url)
    links
    |> Enum.map(&Parsers.URI.expand(base_url, &1))
    |> Enum.map(&fetch(&1, options))
    |> Enum.map(&Task.await/1)
  end

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

  defp render({style_url, {:error, style_result, _}}, _) do
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
