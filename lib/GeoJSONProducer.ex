defmodule PolyBisector.MPProducer do

  defp featureFormatter(coords) do
    %{
      type: "MultiPolygon",
      coordinates: coords
    }
  end

  @doc """
    Takes a polygon list (open) returns a MP (with closed linear ring)
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
