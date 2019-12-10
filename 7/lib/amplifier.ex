defmodule Amplifier do
  def find_for(program) when is_binary(program), do: find_for(parse(program))

  def find_for(program) do
    permutations()
    |> Enum.map(fn weights -> {weights, run(program, weights)} end)
    |> Enum.max_by(fn {_, output} -> output end)
  end

  def run(program, weights, input \\ 0)
  def run(_program, [], input), do: input

  def run(program, [weight | rest], input) do
    [output] = Intcode.run(program, %{input: [weight, input]}).output
    run(program, rest, output)
  end

  def permutations do
    permutations([0, 1, 2, 3, 4])
  end

  # perms([]) -> [[]];
  # perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

  def permutations([]), do: [[]]

  def permutations(list) do
    for head <- list, tail <- permutations(list -- [head]), do: [head | tail]
  end

  def parse(string) do
    string
    |> String.split(~r/[\s,]+/)
    |> Enum.map(&String.to_integer/1)
  end
end
