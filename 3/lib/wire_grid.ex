defmodule WireGrid do
  def manhattan_from_file(name) do
    {str1, str2} = texts_from_file(name)
    manhattan_distance(str1, str2)
  end

  def texts_from_file(name) do
    File.stream!(name)
    |> Enum.to_list()
    |> List.to_tuple()
  end

  def manhattan_distance(str1, str2) do
    [str1, str2]
    |> Enum.map(&wire_from_text/1)
    |> Enum.map(&MapSet.new/1)
    |> (fn [a, b] -> MapSet.intersection(a, b) end).()
    |> MapSet.to_list()
    |> List.delete({0, 0})
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  def wire_from_text(string) do
    instructions_from_text(string)
    |> wire_from_instructions([{0, 0}])
  end

  def instructions_from_text(string) do
    Regex.scan(~r/([RLUD])(\d+)/, string)
    |> Enum.map(fn [_, dir, count] -> {dir, String.to_integer(count)} end)
  end

  defp wire_from_instructions([], positions), do: Enum.reverse(positions)

  defp wire_from_instructions([{_, 0} | rest], positions),
    do: wire_from_instructions(rest, positions)

  defp wire_from_instructions([{dir, n} | rest], positions = [previous | _]) do
    wire_from_instructions([{dir, n - 1} | rest], [position(dir, previous) | positions])
  end

  defp position("R", {x, y}), do: {x + 1, y}
  defp position("L", {x, y}), do: {x - 1, y}
  defp position("U", {x, y}), do: {x, y + 1}
  defp position("D", {x, y}), do: {x, y - 1}
end
