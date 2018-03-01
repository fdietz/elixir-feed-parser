defmodule ElixirFeedParser.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_feed_parser,
     version: "2.0.1",
     elixir: "~> 1.6.2",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :xmerl, :tzdata]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:timex, "~> 3.1.13"},
      {:ex_doc, ">= 0.0.0", only: :dev}
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
      links: %{"GitHub" => "https://github.com/fdietz/elixir-feed-parser"}
    ]
  end
end
