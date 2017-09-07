defmodule PolyPartition.Output.Test do
  use ExUnit.Case
  import PolyPartition
  alias PolyPartition.Helpers
  alias PolyPartition.Output
  alias PolyPartition.Fixtures

  describe "Output" do
    test "produces a MP map" do
      result = Output.mPProducer(Fixtures.non_convex)
      assert is_map(result)
      assert Map.has_key?(result, :type)
      assert Map.has_key?(result, :coordinates)
      assert result == %{
        type: "MultiPolygon",
        coordinates: [
          [
            [
              [0, 1],
              [0.25, 0.25],
              [1, 0],
              [0.25, -0.25],
              [0, -1],
              [0.1, 0.1],
              [-1, 0],
              [-0.25, 0.25],
              [0, 1],
            ]
          ]
        ]
      }
    end
  end

  describe "getPolys" do
    test "getPolys" do
      result = PolyPartition.getPolys(hd(Fixtures.realinput))
      assert is_list(result)
      assert length(result) == 2
    end

    test "getAllPolys" do
      result = PolyPartition.getAllPolys(Fixtures.realinput)
      assert is_list(result)
      assert length(result) == 3
      assert List.first(hd(result)) != List.last(hd(result))
    end
  end


end

