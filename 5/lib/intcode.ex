defmodule Intcode do
  import Enum, only: [at: 2]

  def run(memory), do: run(memory, %{})

  def run(memory, context) do
    context =
      context
      |> Map.put_new(:ip, 0)
      |> Map.put_new(:input, [])
      |> Map.put_new(:output, [])

    run(at(memory, context.ip), memory, context)
  end

  @add 1
  @mul 2
  @read 3
  @write 4
  @hlt 99

  def run(@add, memory, context = %{ip: ip}) do
    memory
    |> update(ip + 3, atat(memory, ip + 1) + atat(memory, ip + 2))
    |> run(%{context | ip: ip + 4})
  end

  def run(@mul, memory, context = %{ip: ip}) do
    memory
    |> update(ip + 3, atat(memory, ip + 1) * atat(memory, ip + 2))
    |> run(%{context | ip: ip + 4})
  end

  def run(@read, memory, context = %{ip: ip, input: [head | tail]}) do
    memory
    |> update(ip + 1, head)
    |> run(%{context | ip: ip + 2, input: tail})
  end

  def run(@write, memory, context = %{ip: ip, output: output}) do
    run(memory, %{context | ip: ip + 2, output: [atat(memory, ip+1) | output]})
  end

  def run(@hlt, memory, context = %{output: output}) do
    %{context | output: Enum.reverse(output)}
    |> Map.put_new(:memory, memory)
  end

  defp update(memory, position, value) do
    List.replace_at(memory, at(memory, position), value)
  end

  defp atat(memory, pos) do
    at(memory, at(memory, pos))
  end
end
