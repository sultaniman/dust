defmodule Dust.Parsers do
  @moduledoc """
  Parsers API provides abstractions to
  get relevant assets from the DOM.
  """
  alias Dust.Parsers.{CSS, JS}

  def css(document, _original_request) do
    CSS.parse(document)
  end

  def js(document, _original_request) do
    JS.parse(document)
  end
end
