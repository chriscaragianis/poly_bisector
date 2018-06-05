defmodule PolyPartition.Output do
  @moduledoc"""
  Tools to normalize the output of the partition process
  """

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

  defp featureFormatter(coords) do
    %{
      type: "MultiPolygon",
      coordinates: coords
    }
  end

  @doc """
    Takes a polygon list (open or closed) returns a MP (with closed linear ring)
  """
  def mPProducer(coords) do
    cds = cond do
      List.first(coords) == List.last(coords) -> coords
      true -> coords ++ [List.first(coords)]
    end
    %{
      type: "MultiPolygon",
      coordinates: [
        [
          cds
        ]
      ]
    }
  end

end
