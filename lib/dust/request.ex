defmodule Dust.Request do
  @moduledoc false
  alias Dust.Result

  @type url() :: String.t()
  @type options() :: Keyword.t() | any()

  @spec fetch(url(), options()) :: Result.t()
  def fetch(_url, _options) do
    %Result{
      content: "blabla"
    }
  end
end
