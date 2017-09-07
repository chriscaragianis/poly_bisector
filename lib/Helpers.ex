defmodule PolyPartition.Helpers do

  def det(p, q) do
    [x1, y1] = p
    [x2, y2] = q
    (x1 * y2) - (x2 * y1)
  end

  def det_seg(seg) do
    [p, q] = seg
    det(p, q)
  end

  def sgn_to_bool(a, b) do
    cond do
      a * b < 0 -> true
      true -> false
    end
  end

  def next(n) do
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

end

