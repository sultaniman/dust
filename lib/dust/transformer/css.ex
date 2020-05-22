defmodule Dust.Transformer.CSS do
  @moduledoc false
  use Dust.Types
  alias Dust.Request.{ClientState, Util}

  @spec extract(content()) :: list(String.t())
  def extract(content) do
    with {:ok, document} <- Floki.parse_document(content) do
      parse_style(document) ++ parse_link(document)
    end
  end

  @spec fetch(links(), Keyword.t()) :: list()
  def fetch(links, opts) do
    client = Keyword.get(opts, :client, %ClientState{headers: %{}, opts: [], full_url: ""})
    Enum.map(links, fn src ->
      link = Util.normalize_url(client.full_url, src)
      case HTTPoison.get(link, client.headers, client.opts) do
        {:ok, response} -> {src, response}
        {:error, reason} -> {src, reason}
      end
    end)
  end

  @spec embed(links(), content(), keyword()) :: list(String.t())
  def embed(elements, content, opts \\ []) do
    client = Keyword.get(opts, :client, %ClientState{headers: %{}, opts: []})

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
