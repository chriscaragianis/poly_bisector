defmodule PolyPartition.Helpers.Test do
  use ExUnit.Case
  alias PolyPartition.Helpers
  alias PolyPartition.Fixtures

  describe "Helpers" do
    test "rotate_list" do
      assert Helpers.rotate_list([1,2,3]) == [2, 3, 1]
    end

    test "getPolys" do
      result = PolyPartition.getPolys(hd(Fixtures.realinput))
      assert is_list(result)
      assert length(result) == 2
    end

    test "getAllPolys" do
      result = PolyPartition.getAllPolys(Fixtures.realinput)
      assert is_list(result)
      assert length(result) == 3
      assert List.first(hd(result)) != List.last(hd(result))
    end
  end
end
