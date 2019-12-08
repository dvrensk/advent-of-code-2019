defmodule Orbits do
  def count(string) do
    # small2big = map(string)
    big2smalls = collect(string)
    sum_distances(big2smalls, ["COM"])
  end

  def collect(string) do
    Regex.scan(~r/(\w+)\)(\w+)/, string, capture: :all_but_first)
    |> List.foldl(%{}, fn [a, b], map -> Map.update(map, a, [b], fn old -> [b | old] end) end)
  end

  def sum_distances(big2smalls, nodes, value \\ 0)
  def sum_distances(_big2smalls, nil, _value), do: 0

  def sum_distances(big2smalls, nodes, value) do
    List.foldl(
      nodes,
      length(nodes) * value,
      fn node, ack -> ack + sum_distances(big2smalls, big2smalls[node], value + 1) end
    )
  end

  def map(string) do
    Regex.scan(~r/(\w+)\)(\w+)/, string, capture: :all_but_first)
    |> Enum.map(fn [a, b] -> {b, a} end)
    |> Enum.into(%{})
  end
end
