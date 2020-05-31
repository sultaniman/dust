defmodule Dust.Report do
  @moduledoc """
  Report struct to store insights about each resource
  """
  use TypedStruct

  @typedoc "Report"
  typedstruct do
    field :url, String.t() | nil
    field :type, String.t() | nil
    field :size, String.t() | nil
    field :duration, non_neg_integer()
    field :error, any()
  end
end
