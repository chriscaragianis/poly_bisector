defmodule PolyBisector.Helpers.Test do
  use ExUnit.Case
  alias PolyBisector.Helpers
  alias PolyBisector.Fixtures


  defp polylist_to_set(list) do
    setlist = Enum.map(list, fn(x) -> MapSet.new(x) end)
    MapSet.new(setlist)
  end

  describe "Helpers" do
    test "get segments" do
      assert do
        Fixtures.convex
        |> Helpers.get_segments
        |> polylist_to_set
        ==
        Fixtures.convex_segs
        |> polylist_to_set
      end
    end

    test "intersect?" do
      assert Helpers.intersect?([[-1, 0], [1, 0]], [[0, 1], [0, -1]]) == true
      assert Helpers.intersect?([[0, 1], [0, -1]], [[-1, 0], [1, 0]]) == true
      assert Helpers.intersect?([[-1, 0], [1, 0]], [[5, 1], [5, -1]]) == false
      assert Helpers.intersect?([[-1, 0], [1, 0]], [[-1, 0], [5, -1]]) == false
      assert Helpers.intersect?([[0, 4], [4, 0]], [[0, 1], [4, 10]]) == true
      assert Helpers.intersect?([[-1, 0], [1, 0]], [[-1, 1], [1, 0]]) == false
      assert Helpers.intersect?([[-1, 0], [1, 0]], [[-1, 0], [1, 0]]) == false
      assert Helpers.intersect?([[-1, 0], [0, 0]], [[-1, 0], [0, -1]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[0, 1], [0.25, 0.25]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[0.25, 0.25], [1, 0]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[1, 0], [0.25, -0.25]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[0.25, -0.25], [0, -1]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[0, -1], [0.1,0.1]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[0.1, 0.1], [-1, 0]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[-1, 0], [-0.25, 0.25]]) == false
      assert Helpers.intersect?([[0, 1], [1, 0]], [[-0.25, 0.25], [0, 1]]) == false
      assert Helpers.intersect?([[0, 1], [0, -1]], [[-0.5, -0.9], [0.1,0.1]]) == true
    end

    test "split" do
      assert Helpers.split(@convex) == @convex_split
      assert Helpers.split(@non_convex) == @non_convex_split
    end

    test "intersect_side?" do
      seg1 = [[0, 1], [1, 0]]
      seg2 = [[0, 1], [0, -1]]
      seg3 = [[0, 1], [0.25, -0.25]]
      assert Helpers.intersect_side?(@non_convex, seg1) == false
      assert Helpers.intersect_side?(@non_convex, seg2) == true
      assert Helpers.intersect_side?(@non_convex, seg3) == false
    end

    test "area" do
      assert Helpers.area(@convex) == 2.0
      #assert Helpers.area(@non_convex) == 0.65
    end

    test "rotate_list" do
      assert Helpers.rotate_list([1,2,3]) == [2, 3, 1]
    end

    test "split_side" do
      assert Helpers.split_side(@triangle) == @triangle_split_side
      assert Helpers.split_side(@triangle2) == @triangle_split_side2
    end
  end
end
