defmodule Dust.Parsers.URI do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """

  @doc """
  Expands relative urls to absolute urls
  and augments things like

  ```
    protocol https
      -> // -> https://..

    relative paths
    ../../../some.css => example.com/styles/some.css
  ```

  We also take care about default scheme which is `https`
  if `relative_path` starts with `//example.com/my/awesome/style`
  """
  @spec expand(String.t(), String.t()) :: String.t()
  def expand(request_url, relative_path) do
    uri = get_uri(request_url)
    # If relative path is an absolute url then
    # we need to return it else we need to parse
    # and return expanded url.
    if abs_path?(uri) do
      URI.to_string(uri)
    else
      expanded =
        relative_path
        |> Path.expand(Path.dirname(uri.path || "/"))

      URI.to_string(%URI{uri | path: expanded})
    end
  end

  defp get_uri(url) do
    uri = URI.parse(url)
    if is_nil(uri.scheme) do
      %URI{uri | scheme: "https"}
    else
      uri
    end
  end

  defp abs_path?(%URI{scheme: nil, host: nil}), do: false
  defp abs_path?(%URI{scheme: nil}), do: false
  defp abs_path?(%URI{scheme: _}), do: true
end
