defmodule Dust.Asset do
  @moduledoc """
  Asset struct, keeps

    1. relative url,
    2. absolute url,
    3. `Dust.Requests.Result`
  """
  use TypedStruct

  alias Dust.Requests.Result

  @typedoc "Asset struct"
  typedstruct do
    field :relative_url, String.t()
    field :absolute_url, String.t()
    field :result, Result.t()
  end
end
