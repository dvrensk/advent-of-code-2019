defmodule Intcode do
  import Enum, only: [at: 2]

  def run(memory, ip \\ 0) do
    case calc(memory, ip) do
      {:update, pos, val} ->
        List.replace_at(memory, pos, val)
        |> run(ip + 4)

      {:halt} ->
        memory
    end
  end

  @add 1
  @mul 2
  @hlt 99

  defp calc(memory, ip) do
    case at(memory, ip) do
      @add ->
        {:update, at(memory, ip + 3), value(memory, ip + 1) + value(memory, ip + 2)}

      @mul ->
        {:update, at(memory, ip + 3), value(memory, ip + 1) * value(memory, ip + 2)}

      @hlt ->
        {:halt}
    end
  end

  defp value(memory, pos) do
    at(memory, at(memory, pos))
  end

  def find(output, nounverb \\ 0) when nounverb < 10000 do
    noun = div(nounverb, 100)
    verb = Integer.mod(nounverb, 100)

    case hd(run(well_known_program(noun, verb))) do
      ^output ->
        nounverb

      _ ->
        find(output, nounverb + 1)
    end
  end

  def well_known_program(noun, verb) do
    [
      1,
      noun,
      verb,
      3,
      1,
      1,
      2,
      3,
      1,
      3,
      4,
      3,
      1,
      5,
      0,
      3,
      2,
      1,
      9,
      19,
      1,
      19,
      5,
      23,
      2,
      23,
      13,
      27,
      1,
      10,
      27,
      31,
      2,
      31,
      6,
      35,
      1,
      5,
      35,
      39,
      1,
      39,
      10,
      43,
      2,
      9,
      43,
      47,
      1,
      47,
      5,
      51,
      2,
      51,
      9,
      55,
      1,
      13,
      55,
      59,
      1,
      13,
      59,
      63,
      1,
      6,
      63,
      67,
      2,
      13,
      67,
      71,
      1,
      10,
      71,
      75,
      2,
      13,
      75,
      79,
      1,
      5,
      79,
      83,
      2,
      83,
      9,
      87,
      2,
      87,
      13,
      91,
      1,
      91,
      5,
      95,
      2,
      9,
      95,
      99,
      1,
      99,
      5,
      103,
      1,
      2,
      103,
      107,
      1,
      10,
      107,
      0,
      99,
      2,
      14,
      0,
      0
    ]
  end
end
