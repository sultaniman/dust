defmodule Dust.Transformer.CSS do
  @moduledoc false

  def extract(content) do
    with {:ok, document} <- Floki.parse_document(content) do
      link_css = parse_link(document)
      link_css = parse_link(document)
    end
  end

  def embed(content, elements, opts \\ []) do
    content
  end

  defp parse_link(document) do
    document
    |> Floki.find("link[rel=stylesheet]")
    |> Floki.attribute("href")
  end

  defp parse_style(document) do
    document
    |> Floki.find("style")
    |> Floki.text()
  end
end
