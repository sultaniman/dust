defmodule Dust.Types do
  @moduledoc """
  Contains primitive type aliases and typespecs
  """
  defmacro __using__(_) do
    quote do
      # Request related types
      @type url() :: String.t()
      @type content() :: String.t()
      @type links() :: list(String.t())
      @type resource() :: map()
      @type value() :: binary()
      @type headers() :: keyword() | map() | nil

      # For DOM elements
      @type xpath() :: String.to()
      @type pairs() :: list({xpath(), value()})

      # General purpose types
      @type options() :: Keyword.t() | any()
    end
  end
end
