defmodule Currying.Mixfile do
  use Mix.Project

  def project do
    [app: :currying,
     version: "1.0.3",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description()
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
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
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  def package do
    [
      files: ["lib", "mix.exs", "README*",  "LICENSE*"],
      maintainers: ["Qqwy/Wiebe-Marten"],
      licenses: ["MIT"],
      links: %{Github: "https://github.com/qqwy/elixir_currying"} 
    ]
  end

  defp description do
    """
    The Currying library allows you to partially apply (or 'curry') any Elixir function, in a very transparent way.
    It also optionally implements the infix operator `~>` as a synomym for currying.
    """
  end
end
