defmodule Dust.Result do
  @moduledoc """
  Result struct to store response data
  """
  use TypedStruct

  @typedoc "Result struct"
  typedstruct do
    field :content, String.t()
    field :status, non_neg_integer()
    field :headers, map()
    field :images, list()
    field :css, list()
    field :js, list()
    field :svg, list()
    field :json, list()
  end
end
