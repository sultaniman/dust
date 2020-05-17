defmodule Dust.Transformer do
  @moduledoc false
  alias Dust.Transformer.CSS

  def package(result, http_client) do
    styles =
      result.content
      |> CSS.extract()
      |> CSS.embed(result.content, client: http_client)
  end
end
