defmodule Dust.Request.Client do
  @moduledoc false
  use TypedStruct

  @typedoc "HTTP client configuration"
  typedstruct do
    field :opts, map()
    field :headers, map()
  end
end
