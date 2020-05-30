defprotocol Dust.Loaders.Stage do
  @moduledoc false
  @type content() :: binary()
  @type xpath() :: binary()
  @type value() :: binary()
  @type pairs() :: list({xpath(), value()})

  @spec extract(content()) :: pairs()
  def extract(content)

  @spec embed(content(), pairs(), Keyword.t()) :: content()
  def embed(content, elements, opts \\ [])
end
