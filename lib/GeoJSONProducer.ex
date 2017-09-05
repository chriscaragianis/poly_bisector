defmodule PolyBisector.GeoJSONProducer do

  def toGeoJSON(input_list) do
    Poison.encode(%{input: input_list})
  end

end
