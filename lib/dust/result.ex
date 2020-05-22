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
    field :headers, map()
    field :images, list(String.t())
    field :css, list(String.t())
    field :js, list(String.t())
    field :svg, list(String.t())
    field :json, list(String.t())
  end
end
