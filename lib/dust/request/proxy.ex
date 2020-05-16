defmodule Dust.Request.Proxy do
  @moduledoc """
  Proxy configuration struct.
  Proxy address can start with `http/s` or `socks5`.
  """
  use TypedStruct
  alias __MODULE__

  @typedoc "Proxy"
  typedstruct do
    field :address, String.t()
    field :username, String.t()
    field :password, String.t()
    field :follow_redirect, boolean(), default: true
    field :max_redirects, non_neg_integer()
  end

  @doc """
  Prepare proxy configuration for `HTTPoison`
  """
  def get_config(%Proxy{} = proxy) do
    prepare_proxy(URI.parse(proxy.address), proxy)
  end

  defp prepare_proxy(%URI{scheme: "socks5"} = uri, %Proxy{} = proxy) do
    config = [
      socks5_user: proxy.username,
      socks5_pass: proxy.password,
      follow_redirect: proxy.follow_redirect,
      max_redirect: proxy.max_redirects
    ]

    if uri.port do
      Keyword.put(config, :proxy, {:socks5, to_charlist(uri.host), uri.port})
    else
      Keyword.put(config, :proxy, {:socks5, to_charlist(uri.host), 80})
    end
  end

  defp prepare_proxy(%URI{} = uri, %Proxy{} = proxy) do
    [
      proxy: to_charlist(uri.host),
      proxy_auth: {proxy.username, proxy.password},
      follow_redirect: proxy.follow_redirect,
      max_redirect: proxy.max_redirects
    ]
  end
end
