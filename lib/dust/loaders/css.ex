defmodule Dust.Loaders.CSS do
  @moduledoc false
  use Dust.Types
  alias Dust.Requests
  alias Dust.Parsers

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

  defp render({style_url, {:ok, style_result, _client}}) do
    """
    <style>
    /*Style source: #{style_url}*/
    #{style_result.content}
    </style>
    """
  end

  ## Private
  defp fetch(url, options) do
    Task.async(fn ->
      {url, Requests.get(url, options)}
    end)
  end
end
