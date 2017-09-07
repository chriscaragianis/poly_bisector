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

  @smallpoly               [
                  [-118.874130249023, 34.176708515026],
                  [-118.874344825745, 34.1781286730964],
                  [-118.877241611481, 34.1770990608781],
                  [-118.876512050629, 34.1755191142507],
                  [-118.873980045319, 34.1756256284364],
                  [-118.874130249023, 34.176708515026]
                ]


  @realinput [
        %{
          "type" => "MultiPolygon",
          "coordinates" => [
            [[
              [
                -88.7750244140625,
                37.99183365313853
              ],
              [
              -88.0828857421875,
              37.339591851359174
            ],
            [
              -86.7205810546875,
              37.48793540168987
            ],
            [
              -86.08337402343749,
              38.14319750166766
            ],
            [
              -87.03369140625,
              39.16414104768742
            ],
            [
              -88.5992431640625,
              39.193948213963665
            ],
            [
              -88.7750244140625,
              37.99183365313853
            ]
          ]
          ],
          ]
        },
      ]

  describe "quick test" do
    {:ok, result} = PolyBisector.get_split_geojson(@realinput, 7500.012)
    IO.puts result
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

