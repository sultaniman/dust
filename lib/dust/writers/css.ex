defmodule Dust.Writers.CSS do
  @moduledoc """
  CSS loader is responsible to

    1. fetch all CSS assets,
    2. Extract and resolve all images,
    3. Inline images as base64 encoded values
  """
  alias Dust.Requests
  alias Dust.Parsers
  alias Dust.Writers.CSS.Inliner

  @type url() :: String.t()
  @type links() :: list(url())
  @type page() :: String.t()
  @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
  @type result_list() :: list({url(), result()})

  def tag, do: :css

  @spec extract(Result.t()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.css(document)
    end
  end

  @spec inline(result_list(), page()) :: String.t()
  def inline(results, page) do
    styles =
      results
      |> Enum.map(&render/1)
      |> Enum.join("\n")

    String.replace(page, "</html>", "#{styles}</html>")
  end

  defp render({style_url, {:ok, style_result, client}}) do
    content = Inliner.inline(style_result.content, client)

    """
    <style>
    /*Style source: #{style_url}*/
    #{content}
    </style>
    """
  end

  defp render({style_url, {:error, style_result, _}}) do
    """
    <!--Failed to load stylesheet: #{style_url}, reason: #{inspect(style_result.error)}-->
    """
  end
end
