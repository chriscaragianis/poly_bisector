defmodule PolyBisector do
  @moduledoc """
  Documentation for PolyBisector.
  """

  @doc """
  """
  defp slope(point1, point2) do
    [x1, y1] = point1
    [x2, y2] = point2
    case x2 - x1 do
      0 -> "vert"
      0.0 -> "vert"
      _ -> (y2 - y1) / (x2 - x1)
    end
  end

  defp point_score(given, sample, m) do
    [h, k] = sample
    [x, y] = given
    y - (m * x) - k + (m * h)
  end

  defp det(p, q) do
    [x1, y1] = p
    [x2, y2] = q
    (x1 * y2) - (x2 * y1)
  end

  defp det_seg(seg) do
    [p, q] = seg
    det(p, q)
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
    [x, y] = point
    [-y, x]
  end

  defp rotate90_seg(seg) do
    Enum.map(seg, fn(x) -> rotate90(x) end)
  end

  defp sgn_to_bool(a, b) do
    cond do
      a * b < 0 -> true
      true -> false
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

  defp flip_seg(seg) do
    [p1, p2] = seg
    [p2, p1]
  end

  defp point_between?(point, p1, p2) do
    [x, _] = point
    [a, _] = p1
    [b, _] = p1
    (a < x && b > x) || (a > x && b < x)
  end

  defp one_side_intersect?(seg1, seg2) do
    [p11 = [x11, y11], p12 = [x12, y12]] = seg1
    [p21 = [x21, y21], p22 = [x22, y22]] = seg2
    m = slope(p11, p12)
    n = slope(p21, p22)
    k1 = case n do
      "vert" -> "vert"
      _ -> point_score(p21, p11, n)
    end
    k2 = case n do
      "vert" -> "vert"
      _ -> point_score(p21, p12, n)
    end
    degen = share_endpoint?(seg1, seg2)
    case {m, n, k1, k2, degen} do
      {_, _, _, _, true} -> false
      {"vert", 0.0, _, _, _} -> perp_intersect?(seg1, seg2)
      {0.0, "vert", _, _, _} -> perp_intersect?(seg2, seg1)
      #{_, _, "vert", "vert", _} -> point_between?(p21, p11, p12)
      {"vert", _, _, _, _} -> one_side_intersect?(rotate90_seg(seg1), rotate90_seg(seg2))
      {_, "vert", _, _, _} -> one_side_intersect?(rotate90_seg(seg2), rotate90_seg(seg1))
      {_, _, "vert", _, _} -> one_side_intersect?(rotate90_seg(seg1), rotate90_seg(seg2))
      {_, _, _, "vert", _} -> one_side_intersect?(rotate90_seg(seg1), rotate90_seg(seg2))
      _ -> sgn_to_bool(k1, k2)
    end
  end

  def intersect?(seg1, seg2) do
    one_side_intersect?(seg1, seg2) && one_side_intersect?(seg2, seg1)
  end



  def intersect_side?(poly, seg) do
    sides = get_segments(poly)
    values = Enum.map(sides, fn(x) -> intersect?(seg, x) end)
    List.foldl(values, false, fn(x, acc) -> x || acc end)
  end

  defp score_vertex(poly, index) do
    abs(length(poly) / 2 - index)
  end

  defp next(n) do
    cond do
      n < 0 -> (-1 * n)
      true -> n + 1
    end
  end

  def split_coord(poly, step) do
    opp_index = round(:math.floor(length(poly) / 2)) + step
    opp = Enum.at(poly, opp_index)
    case intersect_side?(poly, [hd(poly), opp]) do
      true -> split_coord(poly, next(step))
      _ -> opp_index
    end
  end

  def split(poly) do
    opp_index = split_coord(poly, 0)
    result = []
    r = result ++ [Enum.slice(poly, 0..opp_index)] ++ [Enum.slice(poly, opp_index..length(poly)) ++ [hd(poly)]]
    r
  end

  def area(poly) do
    get_segments(poly)
    |> Enum.map(fn(x) -> det_seg(x) end)
    |> List.foldr(0, fn(x, acc) -> x + acc end)
    |> Kernel./(2)
    |> abs
  end

  def split_list(list, bound, prior) do
    IO.inspect list
    case list == prior do
      false ->
        result = []
        Enum.map(list, fn(x) ->
          cond do
            area(x) > bound -> result ++ split(x)
            true -> result ++ [x]
          end
        end)
        |> split_list(bound, list)
      _ -> list
    end
  end

end
