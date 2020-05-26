defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  use Dust.Types
  alias Dust.Requests
  alias Dust.Requests.{Client, Result}

  @spec get(url(), headers(), options()) :: {Client.t(), Result.t()}
  def get(url, headers, options), do: Requests.get(url, headers, options)

  # Dust.get(url, headers, loaders: [:css, :js, :json, :image]) => {:ok, embedded_html, result} | {:error, nil, result}
end
