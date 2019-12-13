defmodule AsteroidGrid do
  def best_view(path) do
    parse(path)
    |> visibility_map()
    |> Enum.map(fn {pos, list} -> {pos, length(list)} end)
    |> Enum.max_by(fn {_pos, n} -> n end)
  end

  def parse(path) do
    rocks =
      File.stream!(path)
      |> Stream.with_index()
      |> Stream.map(&rocks_in_line/1)
      |> Enum.to_list()
      |> List.flatten()

    max_x =
      Enum.map(rocks, fn {x, _} -> x end)
      |> Enum.max()

    max_y =
      Enum.map(rocks, fn {_, y} -> y end)
      |> Enum.max()

    {MapSet.new(rocks), {max_x, max_y}}
  end

  def rocks_in_line({line, y}) do
    String.to_charlist(line)
    |> Enum.with_index()
    |> Enum.map(fn
      {?#, x} -> {x, y}
      _ -> nil
    end)
    |> Enum.filter(fn a -> a end)
  end

  def visibility_map({grid, max}) do
    grid
    |> Enum.map(fn pos -> {pos, visible_from(pos, grid, max)} end)
    |> Enum.into(%{})
  end

  def visible_from(pos, grid, max) do
    other = MapSet.delete(grid, pos)

    hidden =
      other
      |> Enum.map(fn pos2 -> hidden_in_from_by(pos, pos2, max) end)
      |> List.flatten()

    MapSet.difference(other, MapSet.new(hidden))
    |> MapSet.to_list()
  end

  def hidden_in_from_by({x1, y1}, {x2, y2}, max) do
    {dx, dy} = {x2 - x1, y2 - y1}
    gcd = Integer.gcd(dx, dy)
    {dx, dy} = {div(dx, gcd), div(dy, gcd)}
    positions_in_line({x1, y1}, {dx, dy}, gcd, max, []) -- [{x2, y2}]
  end

  def positions_in_line({x1, y1}, {dx, dy}, n, {max_x, max_y}, ack) do
    {x2, y2} = {x1 + dx * n, y1 + dy * n}

    if Enum.member?(0..max_x, x2) && Enum.member?(0..max_y, y2) do
      positions_in_line({x1, y1}, {dx, dy}, n + 1, {max_x, max_y}, [{x2, y2} | ack])
    else
      ack
    end
  end

  def rock?({grid, _max}, pos) do
    MapSet.member?(grid, pos)
  end

  def blank?(grid, pos), do: not rock?(grid, pos)
end
