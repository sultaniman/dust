defmodule Dust.Parsers do
  @moduledoc """
  Parsers API provides abstractions to
  get relevant assets from the DOM.
  """
  alias Dust.Parsers.{CSS, Image, JS}

  def css(document), do: CSS.parse(document)
  def js(document), do: JS.parse(document)
  def image(document), do: Image.parse(document)
end
