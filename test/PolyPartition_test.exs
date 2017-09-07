defmodule PolyPartition.Test do
  use ExUnit.Case
  alias PolyPartition.Fixtures

  @split_polys_test_cases [
    {1, [Fixtures.realsimple], 6, 3},
    #{0, [Fixtures.realsimple, Fixtures.realcomplex], 50, 3},
    #
    #{2, [Fixtures.realcomplex], 60, 2},
    #{3, [Fixtures.realcomplex], 30, 3},
    #{4, [Fixtures.realcomplex], 10, 17},
    #{5, [Fixtures.realsimple, Fixtures.realcomplex], 60, 6},
    #{6, [Fixtures.realsimple, Fixtures.realcomplex, Fixtures.degenerate], 60, 6},
  ]

    test "getPolys" do
      result = Fixtures.realinput
               |> List.first
               |> PolyPartition.getPolys
      assert is_list(result)
      assert length(result) == 2
      assert result == [[
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
        ],
        [
          [
            -86.7205810546875,
            37.48793540168987
          ],
          [
            -86.08337402343749,
            38.14319750166766
          ],
          [
            -88.0828857421875,
            37.339591851359174
          ],
        ]]
    end
    test "getAllPolys" do
      result = PolyPartition.getAllPolys(Fixtures.realinput)
      assert is_list(result)
      assert length(result) == 3
      assert List.first(hd(result)) != List.last(hd(result))
    end

  describe "PolyPartition" do
    test "split_polys" do
      Enum.map(@split_polys_test_cases, fn(x) ->
        {n, a, b, c} = x
        assert PolyPartition.split_polys(a, b) |> length == c,
          ~s(split_polys case #{n} failed )
      end)
    end
  end
end
