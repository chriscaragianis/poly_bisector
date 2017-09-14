# PolyPartition

## Description

Subdivides MultiPolygon geometries in a list until all polygons are less than a given area

`PolyPartition.get_split(<List of MultiPolygon geometries>, <area bound in mi^2>)`

To get a result as a  GeoJSON feature collection:

`PolyPartition.get_split_geojson(<List of MultiPolygon geometries>, <area bound in mi^2>)`

## Example

```elixir
iex(1)> a = %{"coordinates" => [[[[-118.874130249023, 34.176708515026],
...(1)>      [-118.874344825745, 34.1781286730964],
...(1)>      [-118.877241611481, 34.1770990608781],
...(1)>      [-118.876512050629, 34.1755191142507],
...(1)>      [-118.873980045319, 34.1756256284364],
...(1)>      [-118.874130249023, 34.176708515026]]]], "type" => "MultiPolygon"}
%{"coordinates" => [[[[-118.874130249023, 34.176708515026],
     [-118.874344825745, 34.1781286730964],
     [-118.877241611481, 34.1770990608781],
     [-118.876512050629, 34.1755191142507],
     [-118.873980045319, 34.1756256284364],
     [-118.874130249023, 34.176708515026]]]], "type" => "MultiPolygon"}
iex(2)> PolyPartition.get_split([a], 0.02)
[%{coordinates: [[[[-118.874344825745, 34.1781286730964],
      [-118.877241611481, 34.1770990608781],
      [-118.876512050629, 34.1755191142507],
      [-118.874344825745, 34.1781286730964]]]], type: "MultiPolygon"},
 %{coordinates: [[[[-118.876512050629, 34.1755191142507],
      [-118.873980045319, 34.1756256284364],
      [-118.874130249023, 34.176708515026],
      [-118.874344825745, 34.1781286730964],
      [-118.876512050629, 34.1755191142507]]]], type: "MultiPolygon"}]
```
## Installation

```elixir
def deps do
  [{:poly_partition, "~> 0.1.2"}]
end
```

