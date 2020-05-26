defmodule Dust.Requests.Util do
  @moduledoc false
  @type domain() :: binary()
  @type uri() :: binary()

  @spec duration(non_neg_integer()) :: non_neg_integer()
  def duration(start_ms) do
    System.monotonic_time(:millisecond) - start_ms
  end

  @spec normalize_url(domain(), uri()) :: String.t()
  def normalize_url(domain, url) do
    cond do
      String.starts_with?(url, "http") -> url

      String.starts_with?(url, "//") ->
        %{scheme: scheme} = URI.parse(domain)
        "#{scheme || :https}:#{url}"

      true ->
        trimmed = String.trim(domain, "/")
        path = String.trim(url, "/")
        "#{trimmed}/#{path}"
    end
  end
end
