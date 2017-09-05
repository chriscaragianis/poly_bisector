defmodule PolyBisector.GeoJSONProducer do

  @boilerPlate = %{
    type: "FeatureCollection",
    features: []
  }

  @boilerFeature = %{
    type: "Feature",
    properties: %{},
    geometry: {
      type: "Polygon",
      coordinates: []
    }
  }
  def toGeoJSON(input_list) do
    Poison.encode(%{input: input_list})
  end

end
