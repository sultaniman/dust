defmodule Dust.MixProject do
  use Mix.Project

  @vsn "0.0.2-dev"
  @package [
    name: "dust",
    files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
    licenses: ["Apache 2.0"],
    links: %{"GitHub" => "https://github.com/imanhodjaev/dust"}
  ]

  @description "Download web pages as a single HTML"

  def project do
    [
      app: :dust,
      version: @vsn,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: @package,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      # Docs
      name: "Dust",
      source_url: "https://github.com/imanhodjaev/dust",
      homepage_url: "https://github.com/imanhodjaev/dust",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
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
      {:httpoison, "~> 1.8"},
      {:retry, "~> 0.15.0"},
      {:floki, "~> 0.32.0"},
      {:typed_struct, "~> 0.2.1"},
      {:ex_image_info, "~> 0.2.4"},
      {:ex_doc, "~> 0.28.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.3", only: :test},
      {:inch_ex, "~> 2.0", only: [:dev, :test]},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
end
