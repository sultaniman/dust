defmodule Dust.Loaders.JS do
  @moduledoc false
  alias Dust.{Parsers, Requests}

  @type url() :: String.t()
  @type links() :: list(url())
  @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
  @type result_list() :: list({url(), result()})

  @spec extract(Result.t()) :: list(String.t())
  def extract(result) do
    with {:ok, document} <- Floki.parse_document(result.content) do
      Parsers.js(document, result.original_request)
    end
  end

  @spec inline(result_list()) :: {:js, list(String.t())}
  def inline(results) do
    {:js, []}
  end
end
