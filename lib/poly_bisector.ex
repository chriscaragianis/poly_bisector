defmodule PolyBisector do
  @moduledoc """
  Documentation for PolyBisector.
  """

  @doc """
  """
  def rightmost(list) do
    List.foldr(list, hd(list), fn(x, acc) ->
      cond do
        hd(x) > hd(acc) -> x
        true -> acc
      end
    end)
  end

  defp cross(a, b) do
    (Enum.at(a, 0) * Enum.at(b, 1)) - (Enum.at(a, 1)  * Enum.at(b, 0))
  end

  defp dot(a, b) do
    (Enum.at(a, 0) * Enum.at(b, 1)) + (Enum.at(a, 1)  * Enum.at(b, 0))
  end

  defp base(a, b) do
    [Enum.at(b, 0) - Enum.at(a, 0), Enum.at(b, 1) - Enum.at(a, 1)]
  end

  def vector_angle(a, b) do
    cond do
      a == [0, 0] -> 0
      b == [0, 0] -> 0
      true -> :math.atan(cross(a, b) / dot(a, b))
    end
  end

  def polar_angle(p1, p2, p3) do
    p2_1 = base(p2, p1)
    p3_1 = base(p3, p1)
    p2_3 = base(p2, p3)
    p1_3 = base(p1, p3)
    ang1 = vector_angle(p2_1, p3_1)
    ang2 = vector_angle(p1_3, p2_3)
    :math.pi + ang1 + ang2
  end

  def convex(poly) do
    point_list = MapSet.to_list(poly)
    p_0 = rightmost(point_list)
    hull = [p_0]


  end
end
