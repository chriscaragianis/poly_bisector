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
    [Enum.at(b, 0) - Enum.at(a, 0)]
  end

  def vector_angle(a, b) do
    :math.atan(cross(a, b) / dot(a, b))
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
    p_0 = rightmost(point_list)
    hull = [p_0]


  end
end
