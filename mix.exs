defmodule ElixirFeedParser.Mixfile do
  use Mix.Project

  @source_url "https://github.com/fdietz/elixir-feed-parser"

  def project do
    [
      app: :elixir_feed_parser,
      version: "2.1.0",
      elixir: "~> 1.4",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [applications: [:logger, :xmerl, :tzdata]]
  end

  defp deps do
    [
      {:timex, "~> 3.4"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    An Elixir Atom/RSS2 feed parser.
    """
  end

  defp package do
    [
      contributors: ["fdietz@gmail.com"],
      maintainers: ["fdietz@gmail.com"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end
end
