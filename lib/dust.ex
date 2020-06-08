defmodule Dust do
  @moduledoc """
  Documentation for `Dust`.
  """
  alias Dust.{Loaders, Requests}

  def get(url, options \\ [])

  def get(url, options) do
    # {:ok, result, client_state} = Requests.get(url, options)
    Requests.get(url, options)
    # Loaders.process(result, [], client: client_state)
  end

  def persist(path, contents) do
    with {:ok, file} <- File.open(path, [:write]) do
      IO.binwrite(file, contents)
      File.close(file)
    end
  end
end
