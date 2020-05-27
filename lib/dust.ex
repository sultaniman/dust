defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  use Dust.Types
  alias Dust.Requests
  alias Dust.Requests.{Client, Result}

  @spec get(url(), options()) :: {Client.t(), Result.t()}
  def get(url, options), do: Requests.get(url, options)

  # Dust.get(url, headers, loaders: [:css, :js, :json, :image]) => {:ok, embedded_html, result} | {:error, nil, result}
end
