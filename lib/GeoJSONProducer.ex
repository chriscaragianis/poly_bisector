defmodule PolyBisector.GeoJSONProducer do

  defp geoJSONFormatter(featuresArray) do
    %{
      type: "FeatureCollection",
      features: featuresArray
    }
  end

  defp featureFormatter(coords) do
    %{
      type: "Feature",
      properties: %{},
      geometry: %{
        type: "Polygon",
        coordinates: coords
      }
    }
  end

  def toGeoJSON(input_list) do
    [featureFormatter(input_list)]
    |> geoJSONFormatter
    |> Poison.encode
  end

end
