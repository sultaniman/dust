defprotocol Dust.Writers.Stage do
  @moduledoc false
  alias Dust.Requests.Result

  @type url() :: String.t()
  @type links() :: list(url())
  @type page() :: String.t()
  @type result() :: {:ok, Result.t()} | {:error, Result.t()}
  @type result_list() :: list({url(), result()})

  @spec extract(Result.t()) :: list(String.t())
  def extract(result)

  @spec inline(result_list(), page()) :: String.t()
  def inline(results, page)
end
