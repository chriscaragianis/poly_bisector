defmodule PolyBisector.Mixfile do
  use Mix.Project

  def project do
    [app: :poly_partition,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps(),
     name: "PolyPartition",
     source_url: "https://github.com/chriscaragianis/poly_bisector"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:geo, "~> 2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "Partition a list of GeoJSON MultiPolygon features until all polygons are below a given area bound"
  end

  defp package() do
    [
      name: "poly_partition",
      files: ["lib", "test", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Chris Caragianis"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/chriscaragianis/poly_bisector"},
    ]
  end
end
