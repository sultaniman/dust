defmodule Dust.Result do
  @moduledoc """
  Result struct to store response data
  """
  use TypedStruct

  @typedoc "Result struct"
  typedstruct do
    field :content, String.t()
    field :status, non_neg_integer()
    field :duration, non_neg_integer()
    field :headers, [{atom, binary}] | [{binary, binary}] | %{binary => binary} | any
    field :images, list()
    field :css, list()
    field :js, list()
    field :svg, list()
    field :json, list()
  end
end
