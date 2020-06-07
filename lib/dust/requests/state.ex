defmodule Dust.Requests.State do
  @moduledoc false
  use TypedStruct
  alias __MODULE__

  @typedoc "HTTP client configuration"
  typedstruct do
    field :base_url, String.t()
    field :options, keyword(), default: []
    field :proxy, keyword(), default: []
    field :headers, map(), default: %{}
  end

  @doc """
  Create `State` with given

    * `url`,
    * `headers`,
    * `options`
  """
  @spec new(String.t(), map(), keyword(), keyword()) :: State.t()
  def new(url, headers, proxy, options) do
    with %{scheme: scheme, host: host, path: path} <- URI.parse(url) do
      %State{
        base_url: "#{scheme || :https}://#{host || path}",
        options: options,
        headers: headers,
        proxy: proxy
      }
    end
  end
end
