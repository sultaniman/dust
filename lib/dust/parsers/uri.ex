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
    cond do
      String.starts_with?(relative_path, "http") ->
        relative_path

      String.starts_with?(relative_path, "//") ->
        "https://#{relative_path}"

      true ->
        expanded =
          relative_path
          |> Path.expand(Path.dirname(uri.path || "/"))

        URI.to_string(%URI{uri | path: expanded})
    end
  end

  def get_base_url(uri) do
    url = URI.parse(uri)
    URI.to_string(%URI{
      scheme: url.scheme || "https",
      host: url.host,
      port: url.port,
      userinfo: url.userinfo
    })
  end

  defp get_uri(url) do
    uri = URI.parse(url)

    if is_nil(uri.scheme) do
      %URI{uri | scheme: "https"}
    else
      uri
    end
  end
end
