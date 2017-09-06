defmodule PolyBisector do
  alias PolyBisector.Helpers
  @moduledoc """
  Documentation for PolyBisector.
  """


  def split_list(list, bound, prior) do
    case list == prior do
      false ->
        result = []
        Enum.flat_map(list, fn(x) ->
          cond do
            Helpers.area(x) > bound -> result ++ Helpers.split(x)
            true -> result ++ [x]
          end
        end)
        |> split_list(bound, list)
      _ -> list
    end
  end

  def split_polys(list, bound) do
    list
    |> Enum.filter(fn(x) -> Helpers.area(x) > 0 end)
    |> split_list(bound, [])
  end

  @doc """
    Takes a MultiPolygon and returns a list of polygons (_not_ linear rings!)
  """
  def getCoords(input) do
    for n <- input["coordinates"], do: hd(n) #NO HOLES IN GONS
  end
end
