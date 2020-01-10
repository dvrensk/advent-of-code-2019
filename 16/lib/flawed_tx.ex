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

  # Saverio's solution:
  def transform_1(list, phases) do
    transform_step(list)
    |> transform(phases - 1)
  end

  # Saverio's solution:
  def transform_step(input) do
    for i <- 1..length(input) do
      input
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {x, j}, acc ->
        case rem(div(j, i), 4) do
          1 -> acc + x
          3 -> acc - x
          _ -> acc
        end
      end)
      |> case do
        0 -> 0
        n when n < 0 -> rem(-n, 10)
        n -> rem(n, 10)
      end
    end
  end

  def transform_one(list, position) do
    Enum.zip(list, factor_pattern_2(position, length(list)))
    |> Enum.reduce(0, fn 
      {_a, 0}, acc -> acc
      {a, 1}, acc -> acc + a
      {a, -1}, acc -> acc - a
    end)
    |> abs()
    |> rem(10)
  end

  def transform_one_0(list, position) do
    Enum.zip(list, factor_pattern_2(position, length(list)))
    |> Enum.map(&pattern_match/1)
    # |> Enum.map(&multiply/1)
    |> Enum.sum()
    |> abs()
    |> Integer.mod(10)
  end

  def multiply({a, factor}), do: a * factor

  def pattern_match({_a, 0}), do: 0
  def pattern_match({a, 1}), do: a
  def pattern_match({a, -1}), do: -a

  def factor_pattern(index) when index > 0 do
    Stream.cycle([0, 1, 0, -1])
    |> Stream.flat_map(fn a -> List.duplicate(a, index) end)
    |> Stream.drop(1)
  end

  def factor_pattern_2(index, len) do
    for i <- 1..len do
      case rem(div(i, index), 4) do
        n when n > 1 -> 2 - n
        n -> n
      end
    end
  end
end
