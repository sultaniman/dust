defmodule Dust.Fetcher do
  @moduledoc false
  alias Dust.{Asset, Parsers, Requests}

  @type asset_type() :: {:css | :js | :image, Asset.t()}
  @type asset_list() :: list(asset_type())

  @task_max_wait_ms 30_000

  def fetch(assets, base_url, options \\ [])

  def fetch(assets, base_url, options) do
    assets
    |> Enum.map(&expand_urls(base_url, &1))
    |> Enum.map(&fetch_async(&1, options))
    |> Enum.map(&Task.await(&1, @task_max_wait_ms))
  end

  @doc """
  Calculates duration metrics
  returns the sum of all durations
  average duration and N times improvement
  with parallel tasks.
  """
  @spec total_duration(keyword()) :: {pos_integer(), float(), float()}
  def total_duration(assets) do
    res =
      assets
      |> Enum.map(fn {_, sub_assets} -> sub_assets end)
      |> List.flatten()

    sum =
      Enum.reduce(res, 0, fn %{result: result}, acc ->
        acc + duration(result)
      end)

    avg = sum / length(res)
    {sum, avg, sum / avg}
  end

  defp duration({:ok, result, _}), do: result.duration
  defp duration({:error, _, _}), do: 0

  defp fetch_async({type, assets}, options) do
    {headers, options} = Keyword.pop(options, :headers, [])
    {proxy_options, options} = Keyword.pop(options, :proxy, [])
    {request_options, _options} = Keyword.pop(options, :options, [])

    options = [
      headers: headers,
      proxy: proxy_options,
      options: request_options
    ]

    Task.async(fn ->
      {
        type,
        assets
        |> Enum.map(&async_asset(&1, options))
        |> Enum.map(&Task.await(&1, @task_max_wait_ms))
      }
    end)
  end

  defp async_asset(asset, options) do
    Task.async(fn ->
      %Asset{asset | result: Requests.get(asset.absolute_url, options)}
    end)
  end

  defp expand_urls(base_url, {type, urls}) do
    {
      type,
      Enum.map(
        urls,
        &%Asset{
          absolute_url: Parsers.URI.expand(base_url, &1),
          relative_url: &1
        }
      )
    }
  end
end
