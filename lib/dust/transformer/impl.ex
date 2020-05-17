defmodule Dust.Transformer.Stage.Impl do
  alias Dust.Transformer.{CSS, Stage}

  defimpl Stage, for: CSS do
    def extract(content), do: CSS.extract(content)
    def embed(content, elements, opts \\ []), do: CSS.embed(content, elements, opts)
  end
end
