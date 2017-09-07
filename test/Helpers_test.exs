defmodule PolyPartition.Helpers.Test do
  use ExUnit.Case
  alias PolyPartition.Helpers
  alias PolyPartition.Fixtures

  @intersect_test_cases [
    {[[-1, 0], [1, 0]], [[0, 1], [0, -1]], true, 0},
    {[[0, 1], [0, -1]], [[-1, 0], [1, 0]], true, 1},
    {[[-1, 0], [1, 0]], [[5, 1], [5, -1]], false, 2},
    {[[-1, 0], [1, 0]], [[-1, 0], [5, -1]], false, 3},
    {[[0, 4], [4, 0]], [[0, 1], [4, 10]], true, 4},
    {[[-1, 0], [1, 0]], [[-1, 1], [1, 0]], false, 5},
    {[[-1, 0], [1, 0]], [[-1, 0], [1, 0]], false, 6},
    {[[-1, 0], [0, 0]], [[-1, 0], [0, -1]], false, 7},
    {[[0, 1], [1, 0]], [[0, 1], [0.25, 0.25]], false, 8},
    {[[0, 1], [1, 0]], [[0.25, 0.25], [1, 0]], false, 9},
    {[[0, 1], [1, 0]], [[1, 0], [0.25, -0.25]], false, 10},
    {[[0, 1], [1, 0]], [[0.25, -0.25], [0, -1]], false, 11},
    {[[0, 1], [1, 0]], [[0, -1], [0.1,0.1]], false, 12},
    {[[0, 1], [1, 0]], [[0.1, 0.1], [-1, 0]], false, 13},
    {[[0, 1], [1, 0]], [[-1, 0], [-0.25, 0.25]], false, 14},
    {[[0, 1], [1, 0]], [[-0.25, 0.25], [0, 1]], false, 15},
    {[[0, 1], [0, -1]], [[-0.5, -0.9], [0.1,0.1]], true, 16}
  ]

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
      @intersect_test_cases
      |> Enum.map(fn(x) ->
        {a, b, c, n} = x
        assert Helpers.intersect?(a, b) == c,
          ~s(intersect? case #{n} failed)
      end)
    end

    test "split" do
      assert Helpers.split(Fixtures.convex) == Fixtures.convex_split
      assert Helpers.split(Fixtures.non_convex) == Fixtures.non_convex_split
    end

    test "intersect_side?" do
      seg1 = [[0, 1], [1, 0]]
      seg2 = [[0, 1], [0, -1]]
      seg3 = [[0, 1], [0.25, -0.25]]
      assert Helpers.intersect_side?(Fixtures.non_convex, seg1) == false
      assert Helpers.intersect_side?(Fixtures.non_convex, seg2) == true
      assert Helpers.intersect_side?(Fixtures.non_convex, seg3) == false
    end

    test "area" do
      assert_in_delta Helpers.area(Fixtures.realsimple), 11.3827, 0.01
      assert_in_delta  Helpers.area(Fixtures.realcomplex), 86.63506, 0.01
    end

    test "rotate_list" do
      assert Helpers.rotate_list([1,2,3]) == [2, 3, 1]
    end

    test "split_side" do
      assert Helpers.split_side(Fixtures.triangle) == Fixtures.triangle_split_side
      assert Helpers.split_side(Fixtures.triangle2) == Fixtures.triangle_split_side2
    end
  end
end
