defmodule Dust.Request.Proxy do
  @moduledoc """
  Proxy configuration struct.
  Proxy address can start with `http/s` or `socks5`.
  """
  use TypedStruct
  alias __MODULE__

  @max_redirects 2

  @typedoc "Proxy"
  typedstruct do
    field :address, String.t()
    field :username, String.t()
    field :password, String.t()
    field :follow_redirect, boolean(), default: true
    field :max_redirects, non_neg_integer(), default: @max_redirects
  end

  @doc """
  Prepare proxy configuration for `HTTPoison`
  """
  @spec get_config(Proxy.t()) :: Keyword.t()
  def get_config(%Proxy{} = proxy) do
    prepare_proxy(URI.parse(proxy.address), proxy)
  end

  defp prepare_proxy(%URI{scheme: "socks5"} = uri, %Proxy{} = proxy) do
    proxy
    |> base_config()
    |> Keyword.merge(get_auth(:socks, proxy, uri))
    |> Keyword.put(:proxy, {:socks5, to_charlist(uri.host), uri.port})
  end

  defp prepare_proxy(%URI{} = uri, %Proxy{} = proxy) do
    proxy
    |> base_config()
    |> Keyword.merge(get_auth(:http, proxy, uri))
    |> Keyword.merge(proxy: to_charlist(uri.host))
  end

  defp base_config(%Proxy{} = proxy) do
    [
      follow_redirect: proxy.follow_redirect,
      max_redirects: proxy.max_redirects
    ]
  end

  defp get_auth(:socks, %Proxy{} = proxy, %URI{} = uri) do
    if proxy.username && proxy.password do
      [socks5_user: proxy.username, socks5_pass: proxy.password]
    else
      if uri.userinfo do
        [username, password] = String.split(uri.userinfo, ":")
        [socks5_user: username, socks5_pass: password]
      else
        []
      end
    end
  end

  defp get_auth(:http, %Proxy{} = proxy, %URI{} = uri) do
    if proxy.username && proxy.password do
      [proxy_auth: {proxy.username, proxy.password}]
    else
      if uri.userinfo do
        [username, password] = String.split(uri.userinfo, ":")
        [proxy_auth: {username, password}]
      else
        []
      end
    end
  end
end
