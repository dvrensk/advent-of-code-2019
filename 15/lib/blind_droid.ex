defmodule BlindDroid do
  @origo {0, 0}

  def shortest_path() do
    {grid, _} = chart(2000)
    graph = build_graph(grid)

    oxygen =
      Enum.find_value(grid, fn
        {pos, 2} -> pos
        _ -> nil
      end)

    :digraph.get_short_path(graph, @origo, oxygen)
  end

  def chart(max \\ -1) do
    droid = start()
    chart(%{@origo => droid}, around(@origo), max)
  end

  def chart(grid, todo, 0), do: {grid, todo}
  def chart(grid, [], _), do: {grid, []}

  def chart(grid, [{pos, direction, pos2} | todo], max) do
    case walk(grid[pos], direction) do
      {_, 0} ->
        Map.put(grid, pos2, 0)
        |> chart(todo, max - 1)

      {_, 2} ->
        Map.put(grid, pos2, 2)
        |> chart(todo, max - 1)

      {droid, 1} ->
        todo = add_around(pos2, grid, todo)

        Map.put(grid, pos2, droid)
        |> chart(todo, max - 1)
    end
  end

  def add_around(pos, grid, todo) do
    seen = Map.keys(grid)
    queued = Enum.map(todo, fn {_, _, pos2} -> pos2 end)

    adding =
      around(pos)
      |> Enum.reject(fn {_, _, pos2} ->
        Enum.member?(seen, pos2) || Enum.member?(queued, pos2)
      end)

    adding ++ todo
  end

  def build_graph(grid) do
    graph = :digraph.new()

    positions =
      Enum.filter(grid, fn
        {_, 0} -> nil
        {_, 2} -> true
        {_pos, _} -> true
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(fn pos -> :digraph.add_vertex(graph, pos) end)

    build_graph(positions, grid, graph)
  end

  def build_graph([], _grid, graph), do: graph

  def build_graph([pos | tail], grid, graph) do
    reachable_neighbours(pos, grid)
    |> Enum.each(fn dest ->
      [_ | _] = :digraph.add_edge(graph, pos, dest)
    end)

    build_graph(tail, grid, graph)
  end

  def reachable_neighbours(pos, grid) do
    around(pos)
    |> Enum.map(&elem(&1, 2))
    |> Enum.filter(fn pos2 -> grid[pos2] > 0 end)
  end

  def around(pos = {x, y}) do
    [
      {pos, 1, {x, y + 1}},
      {pos, 2, {x, y - 1}},
      {pos, 3, {x + 1, y}},
      {pos, 4, {x - 1, y}}
    ]
  end

  def start() do
    {:waiting, droid} =
      Intcode.intlist_from_file("input.txt")
      |> Intcode.run()

    droid
  end

  def walk(droid, direction) do
    {:waiting, next} = Intcode.resume({:waiting, droid}, %{output: [], input: [direction]})
    [output] = next.output
    {next, output}
  end

  def print_grid(grid) do
    IO.puts("---------------------")

    render(grid)
    |> Enum.each(&IO.puts(&1))

    IO.puts("---------------------")
  end

  def render(grid) do
    {x_min, x_max} = Enum.map(Map.keys(grid), &elem(&1, 0)) |> Enum.min_max()
    {y_min, y_max} = Enum.map(Map.keys(grid), &elem(&1, 1)) |> Enum.min_max()
    render_line(y_max, y_min, x_min..x_max, grid, [])
  end

  def render_line(y, y_min, _, _grid, ack) when y < y_min, do: Enum.reverse(ack)

  def render_line(y, y_min, x_range, grid, ack) do
    line =
      x_range
      |> Enum.map(fn x ->
        if {x, y} == @origo do
          "D"
        else
          # Useful symbols: 🁢🀫■✪✩  ※⇕©😀
          case grid[{x, y}] do
            0 -> "#"
            2 -> "⇕"
            nil -> "×"
            _ -> " "
          end
        end
      end)
      |> Enum.join()

    render_line(y - 1, y_min, x_range, grid, [line | ack])
  end
end
