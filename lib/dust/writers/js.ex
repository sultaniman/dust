defmodule Dust.Writers.JS do
  @moduledoc """
  JS loader is responsible to

    1. Extract and resolve all scripts,
    2. Fetch all JS assets,
    3. Inline scripts by appending them at the end of document.
  """
  alias Dust.Requests

  @type url() :: String.t()
  @type links() :: list(url())
  @type page() :: String.t()
  @type result() :: {:ok, Requests.Result.t()} | {:error, Requests.Result.t()}
  @type result_list() :: list({url(), result()})

  def tag, do: :js

  @spec inline(result_list(), page()) :: String.t()
  def inline(results, page) do
    scripts =
      results
      |> Enum.map(&render/1)
      |> Enum.join("\n")

    String.replace(page, "</html>", "#{scripts}</html>")
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
