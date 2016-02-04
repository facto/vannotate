defmodule Vannotate.Mixfile do
  use Mix.Project

  def project do
    [app: :vannotate,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Vannotate],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :scrape,
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:scrape, git: "https://github.com/facto/elixir-scrape"}, # my fork with updated timex
      {:tzdata, "~> 0.1.8", override: true},                    # see https://github.com/bitwalker/timex/issues/86
    ]
  end
end
