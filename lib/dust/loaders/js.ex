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
      Parsers.js(document)
    end
  end

  @spec inline(result_list()) :: {:js, list(String.t())}
  def inline(results) do
    {:js, Enum.map(results, &render/1)}
  end

  defp render({script_url, {:ok, script_result, _client}}) do
    """
    <script type="text/javascript" charset="utf-8">
    /*Script source: #{script_url}*/
    #{script_result.content}
    </script>
    """
  end

  defp render({script_url, {:error, script_result, _}}) do
    """
    <!--Failed to load script: #{script_url}, reason: #{inspect(script_result.error)}-->
    """
  end
end
