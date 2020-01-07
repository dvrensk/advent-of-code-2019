defmodule FlawedTx do
  def transform8(string, phases), do: String.slice(transform(string, phases), 0..7)

  def transform(string, phases) when is_binary(string) do
    String.to_charlist(string)
    |> Enum.map(fn c -> c - ?0 end)
    |> transform(phases)
  end

  def transform(list, 0), do: Enum.map(list, fn n -> n + ?0 end) |> List.to_string()

  def transform(list, phases) do
    Enum.map(1..length(list), &transform_one(list, &1))
    |> transform(phases - 1)
  end

  def transform_one(list, position) do
    Enum.zip(list, factor_pattern(position))
    |> Enum.map(fn {a, factor} -> a * factor end)
    |> Enum.sum()
    |> abs()
    |> Integer.mod(10)
  end

  def factor_pattern(index) when index > 0 do
    Stream.cycle([0, 1, 0, -1])
    |> Stream.flat_map(fn a -> List.duplicate(a, index) end)
    |> Stream.drop(1)
  end
end
