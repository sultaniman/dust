defmodule Dust.MixProject do
  use Mix.Project

  @vsn "0.0.1"
  def project do
    [
      app: :dust,
      version: @vsn,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dust.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:retry, "~> 0.14.0"},
      {:floki, "~> 0.26.0"},
      {:typed_struct, "~> 0.1.4"}
    ]
  end
end
