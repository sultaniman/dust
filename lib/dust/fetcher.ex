defmodule Dust.Fetcher do
  @moduledoc false
  alias Dust.{Parsers, Resource, Requests}

  @type resource_type() :: {:css | :js | :image, Resource.t()}
  @type resource_list() :: list(resource_type())

  def fetch(assets, base_url, options \\ [])
  def fetch(assets, base_url, options) do
    base_url
    |> prepare(assets)
    |> Enum.map(&fetch_async(&1, options))
    |> Enum.map(&Task.await(&1, 30000))
  end

  def total_duration(resources) do
    resources
    |> Enum.map(fn {_, sub_resources} -> sub_resources end)
    |> List.flatten()
    |> Enum.map(fn %{result: {_, result, _}} -> result.duration end)
    |> Enum.sum()
  end

  defp fetch_async({type, resources}, options) do
    {headers, options} = Keyword.pop(options, :headers, [])
    {proxy_options, options} = Keyword.pop(options, :proxy, [])
    {request_options, _options} = Keyword.pop(options, :options, [])
    options = [
      headers: headers,
      proxy: proxy_options,
      options: request_options
    ]

    Task.async(fn ->
      fetched =
        resources
        |> Enum.map(&Task.async(fn ->
          %Resource{&1 | result: Requests.get(&1.absolute_url, options)}
        end))
        |> Enum.map(&Task.await(&1, 30000))

      {type, fetched}
    end)
  end

  defp prepare(base_url, assets) do
    assets
    |> Enum.map(&expand_urls(base_url, &1))
  end

  defp expand_urls(base_url, {type, urls}) do
    {
      type,
      Enum.map(urls, &%Resource{
        absolute_url: Parsers.URI.expand(base_url, &1),
        relative_url: &1
      })
    }
  end
end
