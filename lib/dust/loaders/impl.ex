defmodule Dust.Loaders.Stage.Impl do
  alias Dust.Loaders.{CSS, Stage}

  defimpl Stage, for: CSS do
    def extract(content), do: CSS.extract(content)
  end
end
