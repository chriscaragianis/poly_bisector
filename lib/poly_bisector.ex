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
    tan1 = (Enum.at(p2, 1) - Enum.at(p1, 1)) / (Enum.at(p2, 0) - Enum.at(p1, 0))
    tan2 = (Enum.at(p3, 1) - Enum.at(p2, 1)) / (Enum.at(p3, 0) - Enum.at(p2, 0))
    raw = :math.atan(tan2) - :math.atan(tan1)
    cond do
      raw < 0 -> raw + (2 * :math.pi)
      true -> raw
    end
  end

  def convex(poly) do
    point_list = MapSet.to_list(poly)
    p_0 = leftmost(point_list)
    hull = [p_0]


  end
end
