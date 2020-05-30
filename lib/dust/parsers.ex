defmodule Dust.Parsers do
  @moduledoc """
  Parsers API provides abstractions to
  get relevant assets from the DOM.
  """
  alias Dust.Parsers.CSS

  def css(document, _original_request) do
    CSS.parse(document)
  end
end
