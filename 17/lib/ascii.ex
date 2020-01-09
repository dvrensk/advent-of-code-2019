defmodule Ascii do
  def run() do
    Intcode.intlist_from_file("input.txt")
    |> Intcode.run()
  end

  def intersections() do
    map = grid()
    
    Map.keys(map)
    |> Enum.filter(fn {x,y} -> map[{x+1,y}] && map[{x-1,y}] && map[{x,y+1}] && map[{x,y-1}] end)
  end

  def grid() do
    run().output
    |> List.foldl({%{}, 0, 0}, fn 
      ?., {map, x, y} -> {map, x+1, y}
      10, {map, _, y} -> {map, 0, y+1}
      c, {map, x, y} -> {Map.put(map, {x,y}, c), x+1, y}
     end)
    |> elem(0)
  end
end
