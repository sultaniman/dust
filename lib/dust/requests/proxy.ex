defmodule Dust.Requests.Proxy do
  @moduledoc """
  Proxy configuration struct.
  Proxy address can start with `http/s` or `socks5`.
  It is also possible to only specify `address` field
  and when you call `Proxy.get_config/1` then we try to
  parse URI to figure out type, auth details in this case
  default values will be also applied.

  ```elixir
  # 2 fields with default values
  %Proxy{
    address: "socks5://user:pass@awesome.host:port"
    username: "user",
    password: "pass"
  }
  ```
  """
  use TypedStruct
  alias __MODULE__

  @typedoc "Proxy"
  typedstruct do
    field :address, String.t()
    field :username, String.t()
    field :password, String.t()
  end

  def get_config(nil), do: []
  def get_config(proxy) when is_list(proxy) do
    proxy
  end

  @doc """
  Prepare proxy configuration for `HTTPoison`
  """
  @spec get_config(Proxy.t()) :: Keyword.t()
  def get_config(%Proxy{} = proxy) do
    prepare_proxy(URI.parse(proxy.address), proxy)
  end

  defp prepare_proxy(%URI{scheme: "socks5"} = uri, %Proxy{} = proxy) do
    []
    |> Keyword.merge(get_auth(:socks, proxy, uri))
    |> Keyword.put(:proxy, {:socks5, to_charlist(uri.host), uri.port})
  end

  defp prepare_proxy(%URI{} = uri, %Proxy{} = proxy) do
    []
    |> Keyword.merge(get_auth(:http, proxy, uri))
    |> Keyword.merge(proxy: to_charlist(uri.host))
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
