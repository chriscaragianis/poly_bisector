defmodule PolyPartition.Geometry do
  alias PolyPartition.Helpers
  @moduledoc """
  Geometry functions for PolyPartition
  """

  @doc """
  Calculate the squared length of a segment

  Returns float regardless of input
  ## Examples

      iex> PolyPartition.Geometry.sq_length([[0,0], [1,1]])
      2.0

  """
  def sq_length(seg) do
    [[x1, y1], [x2, y2]] = seg
    :math.pow((x2 - x1), 2) + :math.pow((y2 - y1), 2)
  end

  @doc """
  Finds the midpoint of a segment

  Returns float regardless of input
  ## Examples

      iex> PolyPartition.Geometry.midpoint([[0,0], [4,4]])
      [2.0, 2.0]
  """
  def midpoint(seg) do
    [[x1, y1], [x2, y2]] = seg
    [(x1 + x2) / 2, (y1 + y2) / 2]
  end

  @doc """
  Calculate the slope of a line through two given points

  Returns float if slope is defined, returns "vert" if line is degenerate or vertical.

  ## Examples

      iex> PolyPartition.Geometry.slope([0,0], [4,4])
      1.0

      iex> PolyPartition.Geometry.slope([0,0], [4,0])
      0.0

      iex> PolyPartition.Geometry.slope([0,0], [0,4])
      "vert"

      iex> PolyPartition.Geometry.slope([0,0], [0,0])
      "vert"
  """
  def slope(point1, point2) do
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

  @doc """
  Approximate (miles/degree)^2 of longitude for a given latitude (in radians)

  ## Examples

      iex> PolyPartition.Geometry.lat_factor(1.4)
      1629.2417131835887
  """
  def lat_factor(lat_rad) do
    :math.pow(((69.0 * :math.cos(lat_rad)) + 69.0) / 2.0, 2)
  end

  @doc """
  Approximate area (square miles) of polygon (long/lat)

  ## Examples

      iex> poly = [ [ -106.19590759277344, 39.35182131761711 ], [ -106.30714416503905, 39.26894242038886 ], [ -106.08879089355467, 39.25671479372372 ] ]
      iex> PolyPartition.Geometry.area(poly)
      36.41104908437559
  """
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

  defp rotate90(point) do
    [x, y] = point
    [-y, x]
  end

  defp rotate90_seg(seg) do
    Enum.map(seg, fn(x) -> rotate90(x) end)
  end

  @doc """
  Determine which side of a line a given point is on

  A line is determined by the `sample` point and slope `m`. Two `given` points that
  are on opposite sides of this line will yield numbers with opposite signs from
  `point_score`.

  ## Examples

      iex> PolyPartition.Geometry.point_score([0,1], [1,1], 1)
      1

      iex> PolyPartition.Geometry.point_score([1,0], [1,1], 1)
      -1
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
  Returns a list of segments representing the sides of the polygon

  ## Examples

      iex> PolyPartition.Geometry.get_segments([[0,1], [0,0], [1,0]])
      [[[0,1], [0,0]], [[0,0], [1,0]], [[1,0], [0,1]]]
  """
  def get_segments(poly) do
    poly ++ [hd(poly)]
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {point, index} = x
      cond do
        index != 0 -> [Enum.at(poly, index - 1), point]
        true -> nil
      end
    end)
    |> List.delete(nil)
  end

  @doc """
  Determine if two segments perpendicular to the axes intersect

  ## Examples

      iex> PolyPartition.Geometry.perp_intersect?([[0,0], [0,1]], [[-1,0.5], [1,0.5]])
      true

      iex> PolyPartition.Geometry.perp_intersect?([[0,0], [0,1]], [[-1,1.5], [1,1.5]])
      false
  """
  def perp_intersect?(seg1, seg2) do
    [[x11, y11], [x12, y12]] = seg1
    [[x21, y21], [x22, _]] = seg2
    cond do
      x11 != x12 -> perp_intersect?(seg2, seg1)
      true ->
        horiz = (x21 - x11) * (x22 - x11)
        vert = (y11 - y21) * (y12 - y21)
        !(horiz >= 0 ||  vert >= 0)
    end
  end

  @doc """
  Determine if two segments share an endpoint

  ## Examples

      iex> PolyPartition.Geometry.share_endpoint?([[1,0], [0,0]], [[1,0], [1,1]])
      true

      iex> PolyPartition.Geometry.share_endpoint?([[1,0], [0,0]], [[5,0], [1,1]])
      false

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
    cond do
      share_endpoint?(seg1, seg2) -> false
      true ->
        [p11, p12] = seg1
        [p21, p22] = seg2
        m = slope(p21, p22)
        k1 = point_score(p11, p21, m)
        k2 = point_score(p12, p22, m)
        Helpers.sgn_to_bool(k1, k2)
    end
  end

  @doc """
  Determine if two segments non-trivially (i.e., excluding endpoints) intersect

  ## Examples

      iex> PolyPartition.Geometry.intersect?([[0,0], [1,1]], [[0,1],[1,0]])
      true

      iex> PolyPartition.Geometry.intersect?([[0,1], [1,1]], [[0,1],[1,0]])
      false

      iex> PolyPartition.Geometry.intersect?([[0,1], [1,1]], [[0,0],[1,0]])
      false
  """
  def intersect?(seg1, seg2) do
    one_side_intersect?(seg1, seg2) && one_side_intersect?(seg2, seg1)
  end

  @doc """
  Determine if a segment intersects a side of the polygon.

  Determine if a segment non-trivially (i.e., excluding endpoints) intersects a side
  of the given polygon _excepting the sides incident to the first vertex_.

  ## Examples

      iex> poly = [[0,1], [1,1], [1,0], [0,0]]
      iex> PolyPartition.Geometry.intersect_side?(poly, [[0.5,0.5], [1.5,0.5]])
      true

      iex> poly = [[0,1], [1,1], [1,0], [0,0]]
      iex> PolyPartition.Geometry.intersect_side?(poly, [[1.5,1.5], [5.5,1.5]])
      false
  """
  def intersect_side?(poly, seg) do
    poly
    |> get_segments
    |> Enum.slice(1..length(poly) - 1)
    |> Enum.map(fn(x) -> intersect?(seg, x) end)
    |> List.foldl(false, fn(x, acc) -> x || acc end)
  end

  @doc """
  Determine if a segment is a valid partition boundary in the polygon

  Given `opp_index`, determine if the segment from the first vertex to the
  vertex at `opp_index` forms a valid partition boundary.

      iex> poly = [[0,1], [1, 0], [2, 0], [3,1], [2,2], [2,0.5]]
      iex> PolyPartition.Geometry.good_cut?(poly, 2)
      true

      iex> poly = [[0,1], [1, 0], [2, 0], [3,1], [2,2], [2,0.5]]
      iex> PolyPartition.Geometry.good_cut?(poly, 3)
      false
  """
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
