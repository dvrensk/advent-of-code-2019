defmodule RocketFuel do
  def for_file(path) do
    path
    |> numbers_in_file
    |> Enum.map(&for_weight_and_self/1)
    |> Enum.sum()
  end

  def for_weight(weight) do
    div(weight, 3) - 2
  end

  def for_weight_and_self(weight, memo \\ 0) do
    case for_weight(weight) do
      n when n > 0 ->
        for_weight_and_self(n, memo + n)

      _ ->
        memo
    end
  end

  def numbers_in_file(path) do
    path
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
