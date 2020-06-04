defmodule Dust.Dom do
  @moduledoc false
  @type selector() :: String.t()
  @type attr() :: String.t()
  @type document() :: Floki.html_tree() | Floki.html_tag()

  @spec find(document(), selector(), attr()) :: list(String.t())
  def find(document, selector, attr) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attr)
  end
end
