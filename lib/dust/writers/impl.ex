defmodule Dust.Writers.Stage.Impl do
  @moduledoc false
  alias Dust.Writers.{
    CSS,
    Image,
    JS,
    Stage
  }

  defimpl Stage, for: CSS do
    def extract(content), do: CSS.extract(content)
    def inline(results, page), do: CSS.inline(results, page)
  end

  defimpl Stage, for: Image do
    def extract(content), do: Image.extract(content)
    def inline(results, page), do: Image.inline(results, page)
  end

  defimpl Stage, for: JS do
    def extract(content), do: JS.extract(content)
    def inline(results, page), do: JS.inline(results, page)
  end
end
