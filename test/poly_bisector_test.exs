defmodule PolyBisector.Test do
  import PolyBisector
  use ExUnit.Case

  @non_convex MapSet.new([
        [0, 1],
        [0.5, 0.5],
        [1, 0],
        [0.5, -0.5],
        [0, -1],
        [-0.5, -0.5],
        [-1, 0],
        [-0.5, 0.5]
      ])

  @convex MapSet.new([
        [0, 1],
        [1, 0],
        [0, -1],
        [-1, 0]
      ])

  @degenerate MapSet.new([ [0, 1], [1, 1]])

  describe "PolyBisector" do
    test "convex hull" do
      assert PolyBisector.convex(@non_convex) == @convex
      assert PolyBisector.convex(@convex) == @convex
      assert PolyBisector.convex(@degenerate) == @degenerate
    end

    test "leftmost" do
      assert PolyBisector.leftmost(MapSet.to_list(@non_convex)) == [-1, 0]
    end
  end
end
