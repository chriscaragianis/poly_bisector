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

  defp slope(point1, point2) do
    case Enum.at(point2, 0) - Enum.at(point1, 0) do
      0 -> "vert"
      _ -> (Enum.at(point2, 1) - Enum.at(point1, 1))
        / (Enum.at(point2, 0) - Enum.at(point1, 0))
    end
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

  def get_segments(poly) do
    sides = length(poly)
    poly
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {point, index} = x
      [point, Enum.at(poly, rem((index + 1), length(poly)))]
    end)
  end

  defp rotate90(point) do
    [Enum.at(point, 1), Enum.at(point, 0)]
  end

  defp rotate90_seg(seg) do
    Enum.map(seg, rotate(90))
  end

  defp sgn_to_bool(a, b) do
    cond do
      a * b >= 0 -> false
      true -> true
    end
  end

  defp perp_intersect?(seg1, seg2) do
    #vert is first
    [[x1, y11], [_, y12]] = seg1
    [[x21, y2], [x22, _]] = seg2
    horiz = (x21 - x1) * (x22 - x1)
    vert = (y11 - y2) * (y12 - y2)
    !(horiz >= 0 ||  vert >= 0)
  end

  def intersect?(seg1, seg2) do
    [p11 = [x11, y11], p12 = [x12, y12]] = seg1
    [p21 = [x21, y21], p22 = [x22, y22]] = seg2
    m = slope(p11, p12)
    n = slope(p21, p22)
    k1 = slope(p11, p21)
    k2 = slope(p11, p22)
    case {m, n, k1, k2} do
      {"vert", 0.0, _, _} -> perp_intersect?(seg1, seg2)
      {0.0, "vert", _, _} -> perp_intersect?(seg2, seg1)
      {"vert", _, _, _} -> intersect?(rotate90(seg1), rotate90(seg2))
      {_, "vert", _, _} -> intersect?(rotate90(seg2), rotate90(seg1))
      {_, _, "vert", _} -> intersect?(rotate90(seg2), rotate90(seg1))
      {_, _, _, "vert"} -> intersect?(rotate90(seg2), rotate90(seg1))
      _ -> sgn_to_bool(k1, k2)
    end
  end

  def split(poly) do
    sides = get_segments(poly)

  end

end
