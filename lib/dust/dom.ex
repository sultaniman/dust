defmodule Dust.Dom do
  @moduledoc false
  @type selector() :: String.t()
  @type attr() :: String.t()
  @type document() :: Floki.html_tree() | Floki.html_tag()

  @spec attr(document(), selector(), attr()) :: list(String.t())
  def attr(document, selector, attr) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attr)
  end
end
