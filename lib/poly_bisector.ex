defmodule PolyBisector do
  @moduledoc """
  Documentation for PolyBisector.
  """

  @doc """
  """
  def leftmost(list) do
    List.foldr(list, hd(list), fn(x, acc) ->
      if hd(x) < hd(acc) do  acc = x end
    end)
  end

  def convex(poly) do
    point_list = MapSet.to_list(poly)

  end
end
