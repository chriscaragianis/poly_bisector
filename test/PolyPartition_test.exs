defmodule PolyPartition.Test do
  use ExUnit.Case
  alias PolyPartition.Helpers
  alias PolyPartition.Fixtures

  @split_polys_test_cases [
    {0, [Fixtures.realsimple, Fixtures.realcomplex], 150, 3},
    {1, [Fixtures.realsimple], 60, 4},
    {2, [Fixtures.realcomplex], 60, 2},
    {3, [Fixtures.realcomplex], 30, 3},
    {4, [Fixtures.realcomplex], 10, 17},
    {5, [Fixtures.realsimple, Fixtures.realcomplex], 60, 6},
    {6, [Fixtures.realsimple, Fixtures.realcomplex, Fixtures.degenerate], 60, 6},
  ]

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
