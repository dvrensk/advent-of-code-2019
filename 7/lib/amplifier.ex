defmodule Amplifier do
  def find_for(program) when is_binary(program), do: find_for(parse(program))

  def find_for(program) do
    permutations(Enum.to_list(0..4))
    |> Enum.map(fn weights -> {weights, run(program, weights)} end)
    |> Enum.max_by(fn {_, output} -> output end)
  end

  def find_with_feedback(program) when is_binary(program), do: find_with_feedback(parse(program))

  def find_with_feedback(program) do
    permutations(Enum.to_list(5..9))
    |> Enum.map(fn weights -> {weights, run_with_feedback(program, weights)} end)
    |> Enum.max_by(fn {_, output} -> output end)
  end

  def run(program, weights, input \\ 0)
  def run(_program, [], input), do: input

  def run(program, [weight | rest], input) do
    [output] = Intcode.run(program, %{input: [weight, input]}).output
    run(program, rest, output)
  end

  def run_with_feedback(program, weights) do
    weights
    |> Enum.map(fn w -> Intcode.run(program, %{input: [w]}) end)
    |> run_with_feedback([], [0])
    |> hd()
  end

  def run_with_feedback([amp | amps], old, input) do
    case Intcode.resume(amp, %{input: input}) do
      {:waiting, new_state} ->
        waiting = {:waiting, %{new_state | output: []}}
        run_with_feedback(amps, [waiting | old], new_state.output)

      final_state ->
        case amps do
          [] ->
            final_state.output

          _ ->
            run_with_feedback(amps, [final_state | old], final_state.output)
        end
    end
  end

  def run_with_feedback([], old, input) do
    run_with_feedback(Enum.reverse(old), [], input)
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
