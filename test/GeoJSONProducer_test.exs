defmodule PolyBisector.GeoJSONProducer.Test do
  use ExUnit.Case
  import PolyBisector
  alias PolyBisector.Helpers
  alias PolyBisector.MPProducer

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

  @realinput [
        %{
          "type" => "MultiPolygon",
          "coordinates" => [
            [
              [
                [-118.874130249023, 34.176708515026],
                [-118.874344825745, 34.1781286730964],
                [-118.877241611481, 34.1770990608781],
                [-118.876512050629, 34.1755191142507],
                [-118.873980045319, 34.1756256284364],
                [-118.874130249023, 34.176708515026]
              ]
            ],
            [
              [
                [-118.873250484467, 34.1762114540545],
                [-118.872842788696, 34.1746492433684],
                [-118.870525360107, 34.1751818184423],
                [-118.871855735779, 34.1762469585067],
                [-118.873250484467, 34.1762114540545]
              ]
            ]
          ]
        },
        %{
          "type" => "MultiPolygon",
          "coordinates" => [
            [
              [
                [-118.873250484467, 34.1762114540545],
                [-118.872842788696, 34.1746492433684],
                [-118.870525360107, 34.1751818184423],
                [-118.871855735779, 34.1762469585067],
                [-118.873250484467, 34.1762114540545],
              ]
            ]
          ],
        },
      ]

  describe "quick test" do
    coords = PolyBisector.split_polys([@bigpoly], 0.0003)
    #GeoJSONProducer.toGeoJSON(coords)
  end

  describe "MPProducer" do
    test "produces a MP map" do
      result = MPProducer.mPProducer(@non_convex)
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

  describe "getPolys" do
    test "getPolys" do
      result = PolyBisector.getPolys(hd(@realinput))
      assert is_list(result)
      assert length(result) == 2
    end

    test "getAllPolys" do
      result = PolyBisector.getAllPolys(@realinput)
      assert is_list(result)
      assert length(result) == 3
      assert List.first(hd(result)) != List.last(hd(result))
    end
  end


end

