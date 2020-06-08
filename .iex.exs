alias Dust.{
  Dom,
  Loaders,
  Parsers,
  Requests,
}

alias Dust.Loaders.{
  CSS,
  Image,
  JS
}

alias Dust.Requests.{
  ClientState,
  Result,
  Proxy,
  Util
}

defmodule Vars do
  def url, do: "https://hex.pm/docs/publish"
end
