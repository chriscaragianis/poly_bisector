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
      {:ok, result} = GeoJSONProducer.toGeoJSON(@non_convex)
      {:ok, obj} = Poison.decode(result)
      assert is_binary(result)
      assert is_map(obj)
      assert Map.has_key?(obj, "type")
      assert Map.has_key?(obj, "features")
    end
  end
end

