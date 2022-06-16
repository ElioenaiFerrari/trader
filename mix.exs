defmodule Trader.MixProject do
  use Mix.Project

  def project do
    [
      app: :trader,
      version: "0.1.0",
      elixir: "~> 1.14-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        # The main page in the docs
        main: "Trader",
        logo: "assets/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Trader.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.3"},
      {:websockex, "~> 0.4.3"},
      {:number, "~> 1.0"},
      {:httpoison, "~> 1.8"},
      {:ecto, "~> 3.8"},
      {:ecto_sqlite3, "~> 0.7.5"},
      {:mock, "~> 0.3.7"},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false}
    ]
  end
end
