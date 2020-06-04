defmodule Dust.Loaders.CSS do
  @moduledoc """
  CSS loader is responsible to

    1. fetch all CSS assets,
    2. Extract and resolve all images,
    3. Inline images as base64 encoded values
  """
  alias Dust.Requests
  alias Dust.Parsers
  alias Dust.Loaders.CSS.Inliner

  @type url() :: String.t()
  @type links() :: list(url())
  @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
  @type result_list() :: list({url(), result()})

  @spec extract(Result.t()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.css(document, result.original_request)
    end
  end

  @spec template(result_list()) :: {:css, list(String.t())}
  def template(results) do
    {:css, Enum.map(results, &render/1)}
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
    <!--Failed to load: #{style_url}, reason: #{inspect(style_result.error)}-->
    """
  end
end
