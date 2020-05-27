# Dust

**TODO**

## Installation 💾

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dust` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dust, "~> 0.0.1"}
  ]
end
```

## Usage 🧠

```elixir
{:ok, result} =
  url
  |> Dust.get(
    headers: headers,
    proxy: %Proxy{...} | "socks5://user:pass@awesome.host:port",
    max_retries: 3,
    loaders: [:css, :image, :js, :json]
  )
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dust](https://hexdocs.pm/dust).
