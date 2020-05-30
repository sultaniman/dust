defmodule Dust.Loaders.Stage.Impl do
  alias Dust.Loaders.{CSS, Stage}

  defimpl Stage, for: CSS do
    def extract(content), do: CSS.extract(content)
    def embed(content, elements, opts \\ []), do: CSS.embed(content, elements, opts)
  end
end
