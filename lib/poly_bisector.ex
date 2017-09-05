defmodule PolyBisector do
  @moduledoc """
  Documentation for PolyBisector.
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

  defp one_side_intersect?(seg1, seg2) do
    [p11, p12] = seg1
    [p21, p22] = seg2
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

  defp sq_length(seg) do
    [[x1, y1], [x2, y2]] = seg
    :math.pow((x2 - x1), 2) + :math.pow((y2 - y1), 2)
  end

  defp midpoint(seg) do
    [[x1, y1], [x2, y2]] = seg
    [(x1 + x2) / 2, (y1 + y2) / 2]
  end

  def rotate_list(list) do
    list
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {_, index} = x
      Enum.at(list, rem((index + 1), length(list)))
    end)
  end

  def split_side(poly) do
    {_, pt, ind} = poly
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {point, index} = x
      next = Enum.at(poly, rem((index + 1), length(poly)))
      {sq_length([point, next]), midpoint([point, next]), index}
    end)
    |> List.foldr({0, 0, 0}, fn(x, acc) ->
      {length, mid, _} = x
      {a_length, _, _} = acc
      cond do
        length > a_length -> x
        true -> acc
      end
    end)
    List.insert_at(poly, ind + 1, pt)
  end

  def split(poly) do
    p = case length(poly) do
      3 -> split_side(poly)
      _ -> poly
    end
    opp_index = split_coord(p, 0)
    result = []
    r = result ++ [Enum.slice(p, 0..opp_index)] ++ [Enum.slice(p, opp_index..length(p)) ++ [hd(p)]]
    t = r
        |> Enum.map(fn(x) -> area(x) end)
        |> List.foldr(1, fn(x, acc) -> cond do
          x < acc -> x
          true -> acc
        end
        end)
    case t do
      0.0 -> split(rotate_list(poly))
      _ -> r
    end
  end

  def area(poly) do
    get_segments(poly)
    |> Enum.map(fn(x) -> det_seg(x) end)
    |> List.foldr(0, fn(x, acc) -> x + acc end)
    |> Kernel./(2)
    |> abs
  end

  def split_list(list, bound, prior) do
    case list == prior do
      false ->
        result = []
        Enum.flat_map(list, fn(x) ->
          cond do
            area(x) > bound -> result ++ split(x)
            true -> result ++ [x]
          end
        end)
        |> split_list(bound, list)
      _ -> list
    end
  end

  def split_polys(list, bound) do
    list
    |> Enum.filter(fn(x) -> area(x) > 0 end)
    |> split_list(bound, [])
  end

end
