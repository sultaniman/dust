defmodule Dust.Loaders.CSS do
  @moduledoc false
  use Dust.Types
  alias Dust.Requests

  @spec extract(result()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      {:css, parse_style(document) ++ parse_link(document)}
    end
  end

  def load(links, options) do
    base_url = Keyword.get(options, :base_url)
    result =
      links
      |> Enum.map(&fetch(&1, options))
      |> Enum.map(&Task.await/1)
      |> Enum.map(&resolve_url(base_url, &1))

    {:css, result}
  end

  def inject(links) do

  end

  ## Private
  defp fetch(url, options) do
    Task.async(fn ->
      {url, Requests.get(url, options)}
    end)
  end

  defp parse_link(document) do
    document
    |> find("link[rel=stylesheet]", "href")
    |> Enum.map(&resolve_url(base_url, &1))
  end

  defp parse_style(document) do
    find(document, "style", "src")
  end

  defp find(document, selector, attr) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attr)
    |> Enum.filter(&has_uri?/1)
  end

  defp has_uri?(uri) do
    String.trim(uri) != ""
  end

  defp resolve_url(base_uri, style_uri) do

  end
end
