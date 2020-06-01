defmodule Dust.Loaders.CSS do
  @moduledoc false
  use Dust.Types
  alias Dust.Requests
  alias Dust.Parsers

  @css_url_regex ~r/url\(['"]?(?<uri>.*?)['"]?\)/

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

  def template(results, base_url) do
    {:css, Enum.map(results, &render(&1, base_url))}
  end

  defp render({style_url, {:ok, style_result, client}}, base_url) do
    inline_sources =
      @css_url_regex
      |> Regex.scan(style_result.content)
      |> Enum.map(&Enum.at(&1, 1))
      |> Enum.filter(&!String.starts_with?(&1, "data:image"))
      |> Enum.map(&Parsers.URI.expand(base_url, &1))
      |> MapSet.new()
      |> MapSet.to_list()
      |> Enum.map(&fetch(&1, client.options))
      |> Enum.map(&Task.await/1)

    inline_sources
    |> Enum.map(&inline(elem(&1, 0), elem(&1, 1)))
    # IO.inspect("Sources: \n#{(inline_sources)}")
    """
    <style>
    /*Style source: #{style_url}*/
    #{style_result.content}
    </style>
    """
  end

  defp render({style_url, {:error, style_result, _}}, _) do
    """
    <!--Failed to load: #{style_url}, reason: #{inspect(style_result.error)}-->
    """
  end

  defp inline(url, {:ok, result, _}, inline_to) do
    encoded = encode(url, result.content)
    String.replace(inline_to, url, encoded)
  end

  defp encode(url, content) do
    encoded = Base.encode64(content)
    cond do
      String.ends_with?(url, "jpg") -> "data:image/jpg;base64,#{encoded}"
      String.ends_with?(url, "jpeg") -> "data:image/jpg;base64,#{encoded}"
      String.ends_with?(url, "png") -> "data:image/png;base64,#{encoded}"
      String.ends_with?(url, "gif") -> "data:image/gif;base64,#{encoded}"
    end
  end

  ## Private
  defp fetch(url, options) do
    Task.async(fn ->
      {url, Requests.get(url, options)}
    end)
  end
end
