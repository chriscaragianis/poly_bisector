defmodule PolyBisector.Test do
  use ExUnit.Case
  alias PolyBisector.Helpers
  alias PolyBisector.Fixtures

  @split_polys_test_cases [
    {[Fixtures.realsimple, Fixtures.realcomplex], 150, 3},
    {[Fixtures.realsimple], 60, 4},
    {[Fixtures.realcomplex], 60, 2},
    {[Fixtures.realcomplex], 30, 3},
    {[Fixtures.realcomplex], 10, 17},
    {[Fixtures.realsimple, Fixtures.realcomplex], 60, 6},
    {[Fixtures.realsimple, Fixtures.realcomplex, Fixtures.degenerate], 60, 6},
  ]

  describe "PolyBisector" do
    test "split_polys" do
      Enum.map(@split_polys_test_cases, fn(x) ->
        {a, b, c} = x
        assert PolyBisector.split_polys(a, b) == c
      end)
    end
  end
end
