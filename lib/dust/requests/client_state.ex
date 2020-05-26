defmodule Dust.Requests.ClientState do
  @moduledoc false
  use TypedStruct
  alias __MODULE__

  @typedoc "HTTP client configuration"
  typedstruct do
    field :options, keyword(), default: []
    field :headers, map(), default: %{}
    field :full_url, String.t()
  end

  @doc """
  Create `ClientState` with given

    * `url`,
    * `headers`,
    * `options`
  """
  @spec new(String.t(), map(), keyword()) :: ClientState.t()
  def new(url, headers, options) do
    with %{scheme: scheme, host: host, path: path} <- URI.parse(url) do
      %ClientState{
        options: options,
        headers: headers,
        full_url: "#{scheme || :https}://#{host || path}"
      }
    end
  end
end
