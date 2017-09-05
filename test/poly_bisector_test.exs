defmodule PolyBisector.Test do
  use ExUnit.Case
  alias PolyBisector.Helpers

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

  @non_convex_split [
    [
      [0, 1],
      [0.25, 0.25],
      [1, 0],
      [0.25, -0.25],
      [0, -1],
      [0.1, 0.1]
    ],
    [
      [0.1, 0.1],
      [-1, 0],
      [-0.25, 0.25],
      [0, 1]
    ]
  ]

  @convex [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0]
  ]

  @convex_segs [
    [
      [0, 1],
      [1, 0],
    ],
    [
      [1, 0],
      [0, -1],
    ],
    [
      [0, -1],
      [-1, 0],
    ],
    [
      [-1, 0],
      [0, 1],
    ]
  ]

  @convex_split [
    [
      [0, 1],
      [1, 0],
      [0, -1],
    ],
    [
      [0, -1],
      [-1, 0],
      [0, 1],
    ]
  ]

  @triangle [
    [-1, 0],
    [0, 1],
    [1, 0],
  ]

  @triangle_split_side [
    [-1, 0],
    [0, 1],
    [1, 0],
    [0, 0],
  ]

  @triangle2 [
    [1, 0],
    [0, 1],
    [-1, 0],
  ]

  @triangle_split_side2 [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0.0, 0.0],
  ]
  @degenerate [ [0, 1], [1, 1]]

  defp polylist_to_set(list) do
    setlist = Enum.map(list, fn(x) -> MapSet.new(x) end)
    MapSet.new(setlist)
  end

  describe "PolyBisector" do
    test "get segments" do
      assert polylist_to_set(Helpers.get_segments(@convex)) == polylist_to_set(@convex_segs)
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

    test "split_polys" do
      assert length(PolyBisector.split_polys([@convex, @non_convex], 1.5)) == 3
      assert length(PolyBisector.split_polys([@convex], 0.6)) == 4
      assert length(PolyBisector.split_polys([@non_convex], 0.6)) == 2
      assert length(PolyBisector.split_polys([@non_convex], 0.3)) == 3
      assert length(PolyBisector.split_polys([@non_convex], 0.1)) == 17
      assert length(PolyBisector.split_polys([@convex, @non_convex], 0.6)) == 6
      assert length(PolyBisector.split_polys([@convex, @non_convex, @degenerate], 0.6)) == 6
    end

    test "split_side" do
      assert Helpers.split_side(@triangle) == @triangle_split_side
      assert Helpers.split_side(@triangle2) == @triangle_split_side2
    end

    test "rotate_list" do
      assert Helpers.rotate_list([1,2,3]) == [2, 3, 1]
    end
  end
end
