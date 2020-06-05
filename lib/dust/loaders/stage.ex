defprotocol Dust.Loaders.Stage do
  @moduledoc false
  def extract(content)

  def embed(content, elements, opts \\ [])
end
