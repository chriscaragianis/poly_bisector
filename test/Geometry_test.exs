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

  @area_case [
            [
              -85.76640129089355,
              38.24687616739557
            ],
            [
              -85.72837829589844,
              38.22874137177956
            ],
            [
              -85.72357177734375,
              38.23440476759944
            ],
            [
              -85.72691917419434,
              38.243842780560804
            ],
  ]

  @big_area_case [
              [
                            -90.17578124999999,
                            38.634036452919226
                          ],
              [
                            -90.04394531249999,
                            35.146862906756304
                          ],
              [
                            -86.759033203125,
                            36.1733569352216
                          ],
              [
                            -85.7373046875,
                            38.24680876017446
                          ],
            ]
  @big_area_case_segs [
    [
      [
        -90.17578124999999,
        38.634036452919226
      ],
      [
        -90.04394531249999,
        35.146862906756304
      ],
    ],
    [
      [
        -90.04394531249999,
        35.146862906756304
      ],
      [
        -86.759033203125,
        36.1733569352216
      ],
    ],
    [
      [
        -86.759033203125,
        36.1733569352216
      ],
      [
        -85.7373046875,
        38.24680876017446
      ],
    ],
    [

      [
        -85.7373046875,
        38.24680876017446
      ],
      [
        -90.17578124999999,
        38.634036452919226
      ],
    ]
  ]

  describe "Geometry helpers" do
    test "good_cut?" do
      next = Helpers.rotate_list(@good_cutcase)
      assert Geometry.good_cut?(@good_cutcase, 3) == false
      assert Geometry.good_cut?(@good_cutcase, 2) == false
      assert Geometry.good_cut?(@good_cutcase, 1) == false
      assert Geometry.good_cut?(next, 3) == true
    end

    test "get segments" do
      assert Fixtures.convex |> Geometry.get_segments == Fixtures.convex_segs
      assert @big_area_case |> Geometry.get_segments == @big_area_case_segs
    end

    test "intersect?" do
      @intersect_test_cases
      |> Enum.map(fn(x) ->
        {a, b, c, n} = x
        assert Geometry.intersect?(a, b) == c,
          ~s(intersect? case #{n} failed)
      end)
    end

    test "perp_intersect?" do
      seg1 = [ [0, 0], [10, 0] ]
      seg2 = [ [5, -1], [5, 10] ]
      seg3 = [ [5, 1], [5, 10] ]
      assert Geometry.perp_intersect?(seg1, seg2) == true
      assert Geometry.perp_intersect?(seg2, seg1) == true
      assert Geometry.perp_intersect?(seg1, seg3) == false
      assert Geometry.perp_intersect?(seg3, seg1) == false
    end

    test "share_endpoint?" do
      seg1 = [[0,0], [0,1]]
      seg2 = [[1,0], [0,1]]
      seg3 = [[1,0], [2,1]]
      assert Geometry.share_endpoint?(seg1, seg2) == true
      assert Geometry.share_endpoint?(seg1, seg3) == false
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
      assert_in_delta Geometry.area(@area_case), 1.2004, 0.1
      assert_in_delta Geometry.area(@big_area_case), 40141.95, 500.0
    end

    test "point_score" do
      a = Geometry.point_score([10, 1], [1, 1], 1)
      b = Geometry.point_score([1, 10], [1, 1], 1)
      c = Geometry.point_score([1, 11], [1, 1], 1)
      x = Geometry.point_score([1, 0], [0, 0], "vert")
      y = Geometry.point_score([-1, 0], [0, 0], "vert")
      assert a * b < 0
      assert c * b > 0
      assert x * y < 0
    end
  end
end

