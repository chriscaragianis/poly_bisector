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

    test "rightmost" do
      assert PolyBisector.rightmost(MapSet.to_list(@non_convex)) == [1, 0]
    end

    test "polar_angle" do
      assert_in_delta PolyBisector.polar_angle([-1, -1], [0, 0], [1, 0]), 3.92699, 0.0001
      assert_in_delta PolyBisector.polar_angle([1, 1], [0, 0], [-1, 0]), 3.92699, 0.0001
      assert_in_delta PolyBisector.polar_angle([0, 0], [1, 2], [3, 1]), 4.71239, 0.0001
    end

    test "vector_angle" do
      assert_in_delta PolyBisector.vector_angle([-1, 3], [1, 1]), 1.1070623, 0.0001
    end
  end
end
