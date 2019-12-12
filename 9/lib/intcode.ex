defmodule Intcode do
  import Enum, only: [at: 2]

  def run(memory), do: run(memory, %{})

  def run(memory, context) do
    context =
      context
      |> Map.put_new(:ip, 0)
      |> Map.put_new(:input, [])
      |> Map.put_new(:output, [])

    run(op(memory, context.ip), memory, context)
  end

  def resume({:waiting, %{memory: memory, ip: ip, output: output}}, context) do
    context =
      context
      |> Map.put_new(:ip, ip)
      |> Map.put_new(:output, Enum.reverse(output))

    run(memory, context)
  end

  @add 1
  @mul 2
  @read 3
  @write 4
  @jnz 5
  @jz 6
  @lt 7
  @eq 8
  @hlt 99

  def run(@add, memory, context = %{ip: ip}) do
    memory
    |> update(ip + 3, atat(memory, context, 1) + atat(memory, context, 2))
    |> run(%{context | ip: ip + 4})
  end

  def run(@mul, memory, context = %{ip: ip}) do
    memory
    |> update(ip + 3, atat(memory, context, 1) * atat(memory, context, 2))
    |> run(%{context | ip: ip + 4})
  end

  def run(@read, memory, context = %{input: [], output: output}) do
    state =
      %{context | output: Enum.reverse(output)}
      |> Map.put_new(:memory, memory)
      |> Map.delete(:input)

    {:waiting, state}
  end

  def run(@read, memory, context = %{ip: ip, input: [head | tail]}) do
    memory
    |> update(ip + 1, head)
    |> run(%{context | ip: ip + 2, input: tail})
  end

  def run(@write, memory, context = %{ip: ip, output: output}) do
    run(memory, %{context | ip: ip + 2, output: [atat(memory, context, 1) | output]})
  end

  def run(@jnz, memory, context = %{ip: ip}) do
    case atat(memory, context, 1) do
      0 ->
        run(memory, %{context | ip: ip + 3})

      _ ->
        run(memory, %{context | ip: atat(memory, context, 2)})
    end
  end

  def run(@jz, memory, context = %{ip: ip}) do
    case atat(memory, context, 1) do
      0 ->
        run(memory, %{context | ip: atat(memory, context, 2)})

      _ ->
        run(memory, %{context | ip: ip + 3})
    end
  end

  def run(@lt, memory, context = %{ip: ip}) do
    truth = if atat(memory, context, 1) < atat(memory, context, 2), do: 1, else: 0

    memory
    |> update(ip + 3, truth)
    |> run(%{context | ip: ip + 4})
  end

  def run(@eq, memory, context = %{ip: ip}) do
    truth = if atat(memory, context, 1) == atat(memory, context, 2), do: 1, else: 0

    memory
    |> update(ip + 3, truth)
    |> run(%{context | ip: ip + 4})
  end

  def run(@hlt, memory, context = %{output: output}) do
    %{context | output: Enum.reverse(output)}
    |> Map.put_new(:memory, memory)
  end

  defp update(memory, position, value) do
    List.replace_at(memory, at(memory, position), value)
  end

  defp op(memory, ip), do: elem(op_and_modes(memory, ip), 0)
  defp modes(memory, ip), do: elem(op_and_modes(memory, ip), 1)

  defp op_and_modes(memory, ip) do
    packed = at(memory, ip)

    modes =
      div(packed, 100)
      |> Integer.digits()
      |> Enum.reverse()

    {Integer.mod(packed, 100), modes}
  end

  defp atat(memory, _context = %{ip: ip}, offset) do
    case at(modes(memory, ip), offset - 1) do
      1 ->
        at(memory, ip + offset)

      _ ->
        at(memory, at(memory, ip + offset))
    end
  end

  def intlist_from_file(path) do
    File.read!(path)
    |> String.split(~r/[\s,]+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
