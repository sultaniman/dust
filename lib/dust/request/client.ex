defmodule Dust.Request.Client do
  @moduledoc false
  use TypedStruct

  @typedoc "HTTP client configuration"
  typedstruct do
    field :opts, keyword(), default: []
    field :headers, map(), default: %{}
  end
end
