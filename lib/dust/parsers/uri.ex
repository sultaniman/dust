defmodule Dust.Parsers.URI do
  @moduledoc """
  Parse document and returl all links/URIs to
  styles with absolute urls.
  """
  @css_url_regex ~r/url\(['"]?(?<uri>.*?)['"]?\)/

  @doc """
  Extract all CSS `url(...)` links
  """
  @spec parse(String.t()) :: list(String.t())
  def parse(content) do
    @css_url_regex
    |> Regex.scan(content)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.reject(&is_empty?/1)
    |> Enum.reject(&is_data_url?/1)
    |> Enum.reject(&is_font?/1)
  end

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
    uri = normalize(request_url)
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

  @spec get_base_url(String.t()) :: URI.t() | any()
  def get_base_url(uri, domain \\ true)

  def get_base_url(uri, domain) do
    url = URI.parse(uri)

    base = %URI{
      scheme: url.scheme || "https",
      host: url.host,
      port: url.port,
      userinfo: url.userinfo,
      query: nil,
      fragment: nil
    }

    cond do
      domain ->
        URI.to_string(base)

      Path.extname(url.path) == "" ->
        URI.to_string(%URI{base | path: url.path})

      # If we have extension .js, .css etc.
      true ->
        URI.to_string(%URI{base | path: Path.dirname(url.path)})
    end
  end

  def normalize(url, as_string \\ false)

  def normalize(url, as_string) do
    uri = URI.parse(url)

    url_to_string = fn uri ->
      if as_string do
        URI.to_string(uri)
      else
        uri
      end
    end

    if is_nil(uri.scheme) do
      url_to_string.(%URI{uri | scheme: "https"})
    else
      url_to_string.(uri)
    end
  end

  def is_empty?(url) do
    is_nil(url) || String.trim(url) == ""
  end

  def is_font?(url) do
    String.contains?(url, ".ttf") ||
    String.contains?(url, ".woff") ||
    String.contains?(url, ".woff2") ||
    String.contains?(url, ".otf") ||
    String.contains?(url, ".eot") ||
    String.contains?(url, ".ttc")
  end

  def is_data_url?(url) do
    String.starts_with?(url, "data:image")
  end
end
