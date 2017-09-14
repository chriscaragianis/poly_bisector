defmodule PolyPartition.Helpers do
  alias PolyPartition.Geometry
  @moduledoc """
  Helper functions for PolyPartition
  """

  @doc """
  Calculates the determinant of two points provided as a segment

  ## Examples

      iex> PolyPartition.Helpers.det_seg([ [2, 3], [1, -1] ])
      -5

  """
  def det_seg(seg) do
    [p, q] = seg
    det(p, q)
  end

  defp det(p, q) do
    [x1, y1] = p
    [x2, y2] = q
    (x1 * y2) - (x2 * y1)
  end

  @doc """
  Takes two numbers, returns true if their signs differ, false otherwise

  ## Examples

      iex> PolyPartition.Helpers.sgn_to_bool(-1, 2)
      true

      iex> PolyPartition.Helpers.sgn_to_bool(3, 3)
      false

      iex> PolyPartition.Helpers.sgn_to_bool(3, 0)
      false

  """
  def sgn_to_bool(a, b) do
    cond do
      a * b < 0 -> true
      true -> false
    end
  end

  @doc """
  Find the index of the vertex to use to split the polygon

  `split_coord` assumes there is a vertex that is
    - not a neighbor of the first vertex, and
    - is "line of sight" from the first vertex.

  I believe this is always the case for polygons with more than three vertices,
  but haven't proven it.

  `split_coord` will start by testing the vertex farthest away (in circular order)
  from the first vertex and step out one vertex at a time alternating left and right.
  The `step` parameter is incremented by a private function `next`.

  ## Examples

      iex> poly = [[0,1], [1, 0], [2, 0], [3,1], [2,2], [1,2]]
      iex> PolyPartition.Helpers.split_coord(poly, 0)
      3

      iex> poly = [[0,1], [1, 0], [2, 0], [3,1], [2,2], [2,0.5]]
      iex> PolyPartition.Helpers.split_coord(poly, 0)
      2
  """
  def split_coord(poly, step) do
    opp_index = round(:math.floor(length(poly) / 2)) + step
    case Geometry.good_cut?(poly, opp_index) do
      false -> split_coord(poly, next(step))
      _ -> opp_index
    end
  end

  defp next(n) do
    cond do
      n < 0 -> (-1 * n)
      true -> -1 * (n + 1)
    end
  end

  @doc """
  Add a vertex at the midpoint of a polygon's longest side

  If we have a triangle, we need to add a vertex to make a split. We choose the
  longest side to keep the polygon as "fat" as possible

  The generated point will have float coordinates, regardless of input

  ## Examples

      iex> poly = [[0,1], [1,0], [2,1]]
      iex> PolyPartition.Helpers.split_side(poly)
      [[1.0, 1.0], [0,1], [1,0], [2,1],]
  """
  def split_side(poly) do
    {_, pt, ind} = poly
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {point, index} = x
      next = Enum.at(poly, rem((index + 1), length(poly)))
      {Geometry.sq_length([point, next]), Geometry.midpoint([point, next]), index}
    end)
    |> List.foldr({0.0, 0, 0}, fn(x, acc) ->
      {length, _, _} = x
      {a_length, _, _} = acc
      cond do
        length > a_length -> x
        true -> acc
      end
    end)
    List.insert_at(poly, rem((ind + 1), length(poly)), pt)
  end

  @doc """
  Takes a polygon and returns a list of two polygons forming a partition of the first

  If any degenerate polygons are created, we retry with a different initial vertex

  ## Examples

      iex> poly = [[0,1], [1, 0], [2, 0], [3,1], [2,2], [1,2]]
      iex> PolyPartition.Helpers.split(poly, 0)
      [[[0,1], [1,0], [2,0], [3,1]], [[3,1], [2,2], [1,2], [0,1]]]
  """
  def split(poly, retries) do
    cond do
      retries >= length(poly) -> poly
      true ->  p = case length(poly) do
              3 -> split_side(poly)
              _ -> poly
            end
            opp_index = split_coord(p, 0)
            result = []
            r = result ++ rotate_list([Enum.slice(p, 0..opp_index)]) ++ [Enum.slice(p, opp_index..length(p)) ++ [hd(p)]]
            t = r
                |> Enum.map(fn(x) -> Geometry.area(x) end)
                |> List.foldr(1, fn(x, acc) -> cond do
                    x < acc -> x
                    true -> acc
                  end
                end)
            case {t, retries >= length(poly) - 1} do
              {0.0, false} -> split(rotate_list(poly), retries + 1) #split failed, try another vertex
              _ -> r
            end
            end
  end

  defp rotate_list(list) do
    list
    |> Stream.with_index
    |> Enum.map(fn(x) ->
      {_, index} = x
      Enum.at(list, rem((index + 1), length(list)))
    end)
  end
end

