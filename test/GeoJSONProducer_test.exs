defmodule PolyBisector.GeoJSONProducer.Test do
  use ExUnit.Case
  alias PolyBisector.Helpers
  alias PolyBisector.GeoJSONProducer

  @non_convex [
    [0, 1],
    [0.25, 0.25],
    [1, 0],
    [0.25, -0.25],
    [0, -1],
    [0.1, 0.1],
    [-1, 0],
    [-0.25, 0.25]
  ]

  describe "GeoJSONProducer" do
    test "produces valid GeoJSON" do
      assert is_binary(GeoJSONProducer.toGeoJSON(@non_convex))
    end
  end
end

