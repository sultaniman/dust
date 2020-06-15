defmodule Dust.Fetcher.CSS do
  @moduledoc """
  CSS fetcher does the following things

    1. Extracts all image urls from css assets,
    2. Downloads all images,
    3. Extends and returns assets with new images.

  `For each assets[:css] -> extract urls -> Fetcher.fetch() -> Append to assets[:image]`
  """
  alias Dust.{Fetcher, Parsers}
  alias Dust.Requests.State

  @doc """
  Extract all urls for images from css files then
  merge them all into main `assets` list.
  """
  @spec fetch(list(), State.t()) :: list() | keyword()
  def fetch(assets, state) do
    image_assets =
      assets
      |> Keyword.get(:css, [])
      |> Enum.map(&collect_css_urls/1)
      |> bin_results()
      |> Enum.map(&fetch_bin(&1, state))
      |> remap_results()
      |> Dust.List.merge(Keyword.get(assets, :image, []))

    Keyword.put(assets, :image, image_assets)
  end

  defp collect_css_urls(%{result: {:error, _, _state}}), do: []

  defp collect_css_urls(%{result: {:ok, result, _state}}) do
    base_url = Parsers.URI.get_base_url(result.base_url, false)

    result.content
    |> Parsers.URI.parse()
    |> Enum.map(&{base_url, &1})
  end

  defp bin_results(results) do
    results
    |> List.flatten()
    |> Enum.reduce(%{}, fn {key_url, url}, acc ->
      if Map.has_key?(acc, key_url) do
        Map.replace!(acc, key_url, [url | acc[key_url]])
      else
        Map.put_new(acc, key_url, [url])
      end
    end)
  end

  defp fetch_bin({base_url, urls}, state) do
    Fetcher.fetch([image: urls], base_url,
      headers: state.headers,
      proxy: state.proxy,
      options: state.proxy
    )
  end

  defp remap_results(results) do
    results
    |> List.flatten()
    |> Enum.map(fn {_, css_results} -> css_results end)
    |> List.flatten()
  end
end
