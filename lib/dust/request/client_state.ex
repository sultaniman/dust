defmodule Dust.Request.ClientState do
  @moduledoc false
  use TypedStruct

  @typedoc "HTTP client configuration"
  typedstruct do
    field :opts, keyword(), default: []
    field :headers, map(), default: %{}
    field :full_url, String.t()
  end
end
