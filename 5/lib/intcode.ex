defmodule Intcode do
  import Enum, only: [at: 2]

  def run(memory), do: run(memory, %{})

  def run(memory, context) do
    context =
      context
      |> Map.put_new(:ip, 0)
      |> Map.put_new(:input, [])
      |> Map.put_new(:output, [])

    run(op_and_modes(memory, context.ip), memory, context)
  end

  @add 1
  @mul 2
  @read 3
  @write 4
  @hlt 99

  def run({@add, modes}, memory, context = %{ip: ip}) do
    memory
    |> update(ip + 3, atat(memory, ip, 1, modes) + atat(memory, ip, 2, modes))
    |> run(%{context | ip: ip + 4})
  end

  def run({@mul, modes}, memory, context = %{ip: ip}) do
    memory
    |> update(ip + 3, atat(memory, ip, 1, modes) * atat(memory, ip, 2, modes))
    |> run(%{context | ip: ip + 4})
  end

  def run({@read, _modes}, memory, context = %{ip: ip, input: [head | tail]}) do
    memory
    |> update(ip + 1, head)
    |> run(%{context | ip: ip + 2, input: tail})
  end

  def run({@write, modes}, memory, context = %{ip: ip, output: output}) do
    run(memory, %{context | ip: ip + 2, output: [atat(memory, ip, 1, modes) | output]})
  end

  def run({@hlt, _modes}, memory, context = %{output: output}) do
    %{context | output: Enum.reverse(output)}
    |> Map.put_new(:memory, memory)
  end

  defp update(memory, position, value) do
    List.replace_at(memory, at(memory, position), value)
  end

  defp op_and_modes(memory, ip) do
    packed = at(memory, ip)

    modes =
      div(packed, 100)
      |> Integer.digits()
      |> Enum.reverse()

    {Integer.mod(packed, 100), modes}
  end

  defp atat(memory, ip, offset, modes) do
    case at(modes, offset - 1) do
      1 ->
        at(memory, ip + offset)

      _ ->
        at(memory, at(memory, ip + offset))
    end
  end

  def intlist_from_file(path) do
    File.read!(path)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
