defmodule PolyBisector.GeoJSONProducer do

  defp featureFormatter(coords) do
    %{
      type: "MultiPolygon",
      coordinates: coords
    }
  end

  def toGeoJSON(input_list) do
    [featureFormatter(input_list)]
  end

end
