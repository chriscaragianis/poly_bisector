defmodule PolyBisector.GeoJSONProducer.Test do
  use ExUnit.Case
  import PolyBisector
  alias PolyBisector.Helpers
  alias PolyBisector.GeoJSONProducer

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

  @bigpoly [
    [
      -112.81379699707031,
      48.233477824968006
    ],
    [
      -112.83233642578124,
      48.219182942479165
    ],
    [
      -112.80967712402344,
      48.20259587674385
    ],
    [
      -112.79130935668945,
      48.22021230740323
    ]
  ]

  describe "quick test" do
    coords = PolyBisector.split_polys([@bigpoly], 0.0003)
    #GeoJSONProducer.toGeoJSON(coords)
  end

  describe "MPProducer" do
    test "produces a MP map" do
      result = GeoJSONProducer.mPProducer(@non_convex)
      assert is_map(result)
      assert Map.has_key?(result, :type)
      assert Map.has_key?(result, :coordinates)
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

