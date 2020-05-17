defmodule Dust.Transformer.CSS do
  @moduledoc false

  def extract(content) do
    with {:ok, document} <- Floki.parse_document(content) do
      parse_style(document) ++ parse_link(document)
    end
  end

  def embed(elements, content, opts \\ []) do
    client = Keyword.fetch!(opts, :client)
    elements
    |> Enum.map(fn src ->
      HTTPoison.get!(src, client.headers, client.opts)
    end)
  end

  defp parse_link(document) do
    document
    |> Floki.find("link[rel=stylesheet]")
    |> Floki.attribute("href")
    |> Enum.filter(&has_uri?/1)
  end

  defp parse_style(document) do
    document
    |> Floki.find("style")
    |> Floki.attribute("src")
    |> Enum.filter(&has_uri?/1)
  end

  defp has_uri?(uri) do
    String.trim(uri) != ""
  end
end
