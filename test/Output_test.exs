defmodule PolyPartition.Output.Test do
  use ExUnit.Case
  alias PolyPartition.Output
  alias PolyPartition.Fixtures

  describe "Output" do
    test "produces a MP map" do
      closed = Fixtures.non_convex ++ [hd(Fixtures.non_convex)]
      result = Output.mPProducer(Fixtures.non_convex)
      result_closed = Output.mPProducer(closed)
      assert is_map(result)
      assert Map.has_key?(result, :type)
      assert Map.has_key?(result, :coordinates)
      assert result == result_closed
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
end

