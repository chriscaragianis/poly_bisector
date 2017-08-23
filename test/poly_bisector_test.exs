defmodule PolyBisector.Test do
  import PolyBisector
  use ExUnit.Case

  @non_convex [
    [0, 1],
    [0.5, 0.5],
    [1, 0],
    [0.5, -0.5],
    [0, -1],
    [-0.5, -0.5],
    [-1, 0],
    [-0.5, 0.5]
  ]

  @non_convex_split [
    [
      [0, 1],
      [0.5, 0.5],
      [1, 0],
      [0.5, -0.5],
      [0, -1]
    ],
    [
      [0, 1],
      [-0.5, 0.5],
      [-1, 0],
      [-0.5, -0.5],
      [0, -1]
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
      [0, -1],
      [-1, 0],
    ],
    [
      [0, 1],
      [0, -1],
      [1, 0],
    ]
  ]

  @degenerate MapSet.new([ [0, 1], [1, 1]])

  defp polylist_to_set(list) do
    setlist = Enum.map(list, fn(x) -> MapSet.new(x) end)
    MapSet.new(setlist)
  end

  describe "PolyBisector" do
    @tag :skip
    test "convex hull" do
      assert PolyBisector.convex(@non_convex) == @convex
      assert PolyBisector.convex(@convex) == @convex
      assert PolyBisector.convex(@degenerate) == @degenerate
    end

    @tag :skip
    test "rightmost" do
      assert PolyBisector.rightmost(MapSet.to_list(@non_convex)) == [1, 0]
    end

    @tag :skip
    test "polar_angle" do
      assert_in_delta PolyBisector.polar_angle([-1, -1], [0, 0], [1, 0]), 3.92699, 0.0001
      assert_in_delta PolyBisector.polar_angle([1, 1], [0, 0], [-1, 0]), 3.92699, 0.0001
      assert_in_delta PolyBisector.polar_angle([0, 0], [1, 2], [3, 1]), 4.71239, 0.0001
    end

    @tag :skip
    test "vector_angle" do
      assert_in_delta PolyBisector.vector_angle([-1, 3], [1, 1]), -1.1070623, 0.0001
    end

    test "get segments" do
      assert polylist_to_set(PolyBisector.get_segments(@convex)) == polylist_to_set(@convex_segs)
    end

    test "intersect?" do
      assert PolyBisector.intersect?([[-1, 0], [1, 0]], [[0, 1], [0, -1]]) == true
      assert PolyBisector.intersect?([[-1, 0], [1, 0]], [[5, 1], [5, -1]]) == false
    end

    @tag :skip
    test "split" do
      assert polylist_to_set(PolyBisector.split(@convex)) == polylist_to_set(@convex_split)
      assert polylist_to_set(PolyBisector.split(@non_convex)) == polylist_to_set(@non_convex_split)
    end
  end
end
