defmodule PolyPartition.Geometry do
  alias PolyPartition.Helpers

  def sq_length(seg) do
    [[x1, y1], [x2, y2]] = seg
    :math.pow((x2 - x1), 2) + :math.pow((y2 - y1), 2)
  end

  def midpoint(seg) do
    [[x1, y1], [x2, y2]] = seg
    [(x1 + x2) / 2, (y1 + y2) / 2]
  end

  defp slope(point1, point2) do
    [x1, y1] = point1
    [x2, y2] = point2
    case x2 - x1 do
      0 -> "vert"
      0.0 -> "vert"
      _ -> (y2 - y1) / (x2 - x1)
    end
  end

  defp deg_to_rad(deg) do
    deg * 2 * :math.pi / 360
  end

  defp lat_factor(lat_rad) do
    :math.pow(((69.0 * :math.cos(lat_rad)) + 69.0) / 2.0, 2)
  end

  def area(poly) do
    factor = poly
    |> hd
    |> List.last
    |> deg_to_rad
    |> lat_factor
    get_segments(poly)
    |> Enum.map(fn(x) -> Helpers.det_seg(x) end)
    |> List.foldr(0, fn(x, acc) -> x + acc end)
    |> Kernel./(2.0)
    |> abs
    |> Kernel.*(factor)
  end

  def rotate90(point) do
    [x, y] = point
    [-y, x]
  end

  def rotate90_seg(seg) do
    Enum.map(seg, fn(x) -> rotate90(x) end)
  end

  @doc """
    sign of result indicates which side of the line through <sample>
    with slope <m> the point <given> lies on
  """
  def point_score(given, sample, m) do
    [h, k] = sample
    [x, y] = given
    case m do
      "vert" -> h - x
      _ -> y - (m * x) - k + (m * h)
    end
  end

  @doc """
    returns an [ [ [x1, y1], [x2, y2] ], ... ] list representing the
    sides of the polygon
  """
  def get_segments(poly) do
    poly ++ [hd(poly)]
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {point, index} = x
      cond do
        index != 0 -> [point, Enum.at(poly, index - 1)]
        true -> nil
      end
    end)
    |> List.delete(nil)
  end

  @doc """
    determine intersection of segments orthogonal to axes
  """
  def perp_intersect?(seg1, seg2) do
    [[x11, y11], [x12, y12]] = seg1
    [[x21, y21], [x22, y22]] = seg2
    cond do
      x11 != x12 -> perp_intersect?(seg2, seg1)
      true ->
        horiz = (x21 - x11) * (x22 - x11)
        vert = (y11 - y21) * (y12 - y21)
        !(horiz >= 0 ||  vert >= 0)
    end
  end

  @doc """
    Do two segments share an endpoint?
  """
  def share_endpoint?(seg1, seg2) do
    [p11, p12] = seg1
    [p21, p22] = seg2
    p11 == p21 ||
      p11 == p22 ||
      p12 == p21 ||
      p12 == p22
  end

  defp one_side_intersect?(seg1, seg2) do
    [p11, p12] = seg1
    [p21, p22] = seg2
    m1 = slope(p11, p12)
    m2 = slope(p21, p22)
    k1 = point_score(p11, p21, m2)
    k2 = point_score(p12, p22, m2)
    degen = share_endpoint?(seg1, seg2)
    Helpers.sgn_to_bool(k1, k2)
  end

  def intersect?(seg1, seg2) do
    one_side_intersect?(seg1, seg2) && one_side_intersect?(seg2, seg1)
  end

  def intersect_side?(poly, seg) do
    sides = get_segments(poly)
    values = Enum.map(sides, fn(x) -> intersect?(seg, x) end)
    List.foldl(values, false, fn(x, acc) -> x || acc end)
  end

  def good_cut?(poly, opp_index) do
    new1 = [hd(poly), Enum.at(poly, opp_index)] ++ Enum.slice(poly, (opp_index + 1)..length(poly))
    new2 = Enum.slice(poly, 0..opp_index - 1) ++ [Enum.at(poly, opp_index)]
    cond do
      opp_index == 1 || opp_index == length(poly) - 1 -> false
      intersect_side?(poly, [hd(poly), Enum.at(poly, opp_index)]) -> false
      area(new1) > area(poly) || area(new2) > area(poly) -> false
      true -> true
    end
  end

end
