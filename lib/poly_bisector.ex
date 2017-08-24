defmodule PolyBisector do
  @moduledoc """
  Documentation for PolyBisector.
  """

  @doc """
  """
  defp slope(point1, point2) do
    case Enum.at(point2, 0) - Enum.at(point1, 0) do
      0 -> "vert"
      _ -> (Enum.at(point2, 1) - Enum.at(point1, 1))
        / (Enum.at(point2, 0) - Enum.at(point1, 0))
    end
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

  defp share_endpoint?(seg1, seg2) do
    [p11, p12] = seg1
    [p21, p22] = seg2
    cond do
      p11 == p21 -> true
      p11 == p22 -> true
      p12 == p21 -> true
      p12 == p22 -> true
      true -> false
    end
  end

  def intersect?(seg1, seg2) do
    [p11 = [x11, y11], p12 = [x12, y12]] = seg1
    [p21 = [x21, y21], p22 = [x22, y22]] = seg2
    m = slope(p11, p12)
    n = slope(p21, p22)
    k1 = slope(p11, p21)
    k2 = slope(p12, p22)
    degen = share_endpoint?(seg1, seg2)
    case {m, n, k1, k2, degen} do
      {_, _, _, _, true} -> false
      {"vert", 0.0, _, _, _} -> perp_intersect?(seg1, seg2)
      {0.0, "vert", _, _, _} -> perp_intersect?(seg2, seg1)
      {"vert", _, _, _, _} -> intersect?(rotate90(seg1), rotate90(seg2))
      {_, "vert", _, _, _} -> intersect?(rotate90(seg2), rotate90(seg1))
      {_, _, "vert", _, _} -> intersect?(rotate90(seg2), rotate90(seg1))
      {_, _, _, "vert", _} -> intersect?(rotate90(seg2), rotate90(seg1))
      _ -> sgn_to_bool(k1, k2)
    end
  end

  def test_line(poly, index1, index2) do
    # is polar angle good?

    # does it intersect?
  end

  def split(poly) do
    sides = get_segments(poly)

  end

end
