defmodule PolyPartition.Helpers.Test do
  use ExUnit.Case
  alias PolyPartition.Helpers
  alias PolyPartition.Fixtures

  describe "Helpers" do

    test "split" do
      assert Helpers.split(Fixtures.convex, 0) == Fixtures.convex_split
      assert Helpers.split(Fixtures.non_convex, 0) == Fixtures.non_convex_split
    end

    test "split_side" do
      assert Helpers.split_side(Fixtures.triangle) == Fixtures.triangle_split_side
      assert Helpers.split_side(Fixtures.triangle2) == Fixtures.triangle_split_side2
    end

    test "rotate_list" do
      assert Helpers.rotate_list([1,2,3]) == [2, 3, 1]
    end

  end
end
