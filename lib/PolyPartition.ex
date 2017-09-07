defmodule PolyPartition do
  alias PolyPartition.Helpers
  alias PolyPartition.MPProducer
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
  def getPolys(input) do
    for n <- input["coordinates"] do
      cond do
        List.first(hd(n)) == List.last(hd(n)) -> tl(hd(n))
        true -> hd(n) #NO HOLES IN GONS
      end
    end
  end

  @doc """
    Takes a list of multipolygons, gives a list of polygons
  """
  def getAllPolys(input_list) do
    for n <- input_list do
      getPolys(n)
    end
    |> List.foldr([], fn(x, acc) -> acc ++ x end)
  end

  def get_split(input, bound) do
    getAllPolys(input)
    |> split_polys(bound)
    |> Enum.map(fn(x) -> MPProducer.mPProducer(x) end)
  end

  def get_split_geojson(input, bound) do
    getAllPolys(input)
    |> split_polys(bound)
    |> Enum.map(fn(x) -> MPProducer.mPProducer(x) |> wrap_geoJSON_feature end)
    |> wrap_geoJSON
    |> Poison.encode
  end

  def wrap_geoJSON_feature(geo) do
    %{
      type: "Feature",
      properties: %{},
      geometry: geo,
    }
  end

  def wrap_geoJSON(features) do
    %{
      type: "FeatureCollection",
      features: features
    }
  end
end


