<h1 align="center">Dust</h1>
<p align="center">
  <img width="150" height="150" src="https://raw.githubusercontent.com/imanhodjaev/dust/develop/assets/dust.svg"/>
</p>

**NOTE:** Please note this project is still under development so you might experience issues.

## Installation 💾

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dust` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dust, "~> 0.0.2-dev"}
  ]
end
```

## Usage 🧠

```elixir
"https://github.com"
|> Dust.get()
|> Dust.persist("AWESOME/PAGE.HTML")

"https://times.com"
|> Dust.get(
  headers: headers,
  proxy: %Proxy{...} | "socks5://user:pass@awesome.host:port",
  max_retries: 3
)
|> Dust.persist(result, "AWESOME/PAGE.HTML")
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dust](https://hexdocs.pm/dust).

## Assets 💄

https://www.flaticon.com/free-icon/dust_867847
