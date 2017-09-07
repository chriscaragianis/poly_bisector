defmodule PolyPartition.Geometry.Test do
  use ExUnit.Case
  alias PolyPartition.Geometry
  alias PolyPartition.Fixtures
  alias PolyPartition.Helpers

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

  @good_cutcase [
            [
              -85.50659179687499,
              38.148597559924355
            ],
            [
              -85.46401977539062,
              37.97451499202459
            ],
            [
              -85.24017333984375,
              38.003737861469666
            ],
            [
              -85.26763916015625,
              38.18638677411551
            ],
            [
              -85.37200927734375,
              38.04484662140698
            ],
          ]

  defp polylist_to_set(list) do
    setlist = Enum.map(list, fn(x) -> MapSet.new(x) end)
    MapSet.new(setlist)
  end

  describe "Geometry helpers" do
    test "good_cut?" do
      next = Helpers.rotate_list(@good_cutcase)
      assert Geometry.good_cut?(@good_cutcase, 3) == false
      assert Geometry.good_cut?(@good_cutcase, 2) == false
      assert Geometry.good_cut?(@good_cutcase, 1) == false
      assert Geometry.good_cut?(next, 3) == true
    end

    test "get segments" do
      assert do
        Fixtures.convex
        |> Geometry.get_segments
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
        assert Geometry.intersect?(a, b) == c,
          ~s(intersect? case #{n} failed)
      end)
    end

    test "intersect_side?" do
      seg1 = [[0, 1], [1, 0]]
      seg2 = [[0, 1], [0, -1]]
      seg3 = [[0, 1], [0.25, -0.25]]
      assert Geometry.intersect_side?(Fixtures.non_convex, seg1) == false
      assert Geometry.intersect_side?(Fixtures.non_convex, seg2) == true
      assert Geometry.intersect_side?(Fixtures.non_convex, seg3) == false
    end

    test "area" do
      assert_in_delta Geometry.area(Fixtures.realsimple), 11.3827, 0.01
      assert_in_delta  Geometry.area(Fixtures.realcomplex), 86.63506, 0.01
    end

  end
end

