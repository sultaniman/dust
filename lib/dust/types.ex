defmodule Dust.Types do
  @moduledoc """
  Contains primitive type aliases and typespecs
  """
  defmacro __using__(_) do
    quote do
      # Request related types
      @type url() :: String.t()
      @type links() :: list(url())
      @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
      @type result_list() :: list({url(), result()})
    end
  end
end
