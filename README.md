# PolyPartition

## Description

Subdivides a polygons in a list until all are less than a given area

`PolyPartition.split_polys(<List of polygons>, <area bound>)`

To get a result as a  GeoJSON feature collection:

`PolyPartition.split_polys_geoJSON(<List of polygons>, <area bound>)`


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `poly_bisector` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:poly_bisector, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/poly_bisector](https://hexdocs.pm/poly_bisector).

