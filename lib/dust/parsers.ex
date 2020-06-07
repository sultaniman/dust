defmodule Dust.Parsers do
  @moduledoc """
  Parsers API provides abstractions to
  get relevant assets from the DOM.
  """
  alias Dust.Parsers
  alias Dust.Parsers.{CSS, Image, JS}

  @spec parse(String.t()) :: keyword()
  def parse(document) do
    with {:ok, dom} <- Floki.parse_document(document) do
      [
        Task.async(fn -> {:css, css(dom)} end),
        Task.async(fn -> {:js, js(dom)} end),
        Task.async(fn -> {:image, image(dom) ++ parse_urls(document)} end)
      ]
      |> Enum.map(&Task.await(&1))
    end
  end

  @spec parse_urls(String.t()) :: list(String.t())
  def parse_urls(document) do
    Parsers.URI.parse(document)
  end

  def css(document), do: CSS.parse(document)
  def js(document), do: JS.parse(document)
  def image(document), do: Image.parse(document)
end
