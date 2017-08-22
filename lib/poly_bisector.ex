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

  def polar_angle(p1, p2, p3) do
  end

  def convex(poly) do
    point_list = MapSet.to_list(poly)
    p_0 = leftmost(point_list)
    hull = [p_0]


  end
end
