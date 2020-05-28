defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  use Dust.Types
  alias Dust.{Loaders, Requests}
  alias Dust.Requests.{Client, Result}

  @spec get(url(), options()) :: {Client.t(), Result.t()}
  def get(url, options) do
    {:ok, result, client_state} = Requests.get(url, options)
    Loaders.process(result, client_state)
  end
end
