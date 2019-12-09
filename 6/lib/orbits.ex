defmodule Orbits do
  def transfer_count(string, who, whom) do
    {[_start | inward], outward} = transfer(string, who, whom)
    length(inward) + length(outward)
  end

  def transfer(string, who, whom) do
    small2big = map(string)
    path1 = root(small2big, who)
    path2 = root(small2big, whom)
    simplify(path1, path2)
  end

  def root(small2big, who, ack \\ []) do
    case small2big[who] do
      nil ->
        ack

      node ->
        root(small2big, node, [node | ack])
    end
  end

  def simplify(path1, path2, common \\ nil)
  def simplify([a | path1], [a | path2], _common), do: simplify(path1, path2, a)
  def simplify(path1, path2, common), do: {Enum.reverse([common | path1]), path2}

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
