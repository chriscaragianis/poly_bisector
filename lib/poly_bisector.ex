defmodule PolyBisector do
  @moduledoc """
  Documentation for PolyBisector.
  """

  @doc """
  """
  def leftmost(list) do
    List.foldr(list, hd(list), fn(x, acc) ->
      if (hd(x) < hd(acc)) do x end
      acc
    end)
  end

  def convex(poly) do
    point_list = MapSet.to_list(poly)
    p_0 = leftmost(point_list)

  end
end
