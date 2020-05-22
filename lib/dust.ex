defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  use Dust.Types

  @spec get(url(), options()) :: {Client.t(), Result.t()}
  def get(url, options), do: Dust.Request.fetch(url, options)
end
