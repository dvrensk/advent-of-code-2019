defmodule Intcode do
  import Enum, only: [at: 2, at: 3]

  def run(memory), do: run(memory, %{})
  def run(memory, context) when is_list(memory), do: run({memory, %{}}, context)
  def run(path, context) when is_binary(path), do: run({intlist_from_file(path), %{}}, context)

  def run(memory, context) do
    context =
      context
      |> Map.put_new(:ip, 0)
      |> Map.put_new(:input, [])
      |> Map.put_new(:output, [])
      |> Map.put_new(:base, 0)

    case context[:max] do
      0 ->
        {memory, context}

      nil ->
        run(op(memory, context.ip), memory, context)

      n ->
        IO.inspect(context)
        IO.inspect(memory)
        run(op(memory, context.ip), memory, %{context | max: n - 1})
    end
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
  @shift_base 9
  @hlt 99

  def run(@add, memory, context = %{ip: ip}) do
    memory
    |> update(context, 3, atat(memory, context, 1) + atat(memory, context, 2))
    |> run(%{context | ip: ip + 4})
  end

  def run(@mul, memory, context = %{ip: ip}) do
    memory
    |> update(context, 3, atat(memory, context, 1) * atat(memory, context, 2))
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
    |> update(context, 1, head)
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
    |> update(context, 3, truth)
    |> run(%{context | ip: ip + 4})
  end

  def run(@eq, memory, context = %{ip: ip}) do
    truth = if atat(memory, context, 1) == atat(memory, context, 2), do: 1, else: 0

    memory
    |> update(context, 3, truth)
    |> run(%{context | ip: ip + 4})
  end

  def run(@shift_base, memory, context = %{ip: ip, base: base}) do
    run(memory, %{context | ip: ip + 2, base: base + atat(memory, context, 1)})
  end

  def run(@hlt, {memlist, memmap}, context = %{output: output}) do
    %{context | output: Enum.reverse(output)}
    # ignoring memmap for now
    |> Map.put_new(:memory, memlist)
  end

  defp update(memory = {memlist, memmap}, context = %{ip: ip, base: base}, offset, value) do
    position =
      case at(modes(memory, ip), offset - 1, 0) do
        0 -> at(memlist, ip + offset)
        1 -> ip + offset
        2 -> base + at(memlist, ip + offset)
      end

    if position < length(memlist) do
      {List.replace_at(memlist, position, value), memmap}
    else
      {memlist, Map.put(memmap, position, value)}
    end
  end

  defp op(memory, ip), do: elem(op_and_modes(memory, ip), 0)
  defp modes(memory, ip), do: elem(op_and_modes(memory, ip), 1)

  defp op_and_modes({memlist, _memmap}, ip) do
    packed = at(memlist, ip)

    modes =
      div(packed, 100)
      |> Integer.digits()
      |> Enum.reverse()

    {Integer.mod(packed, 100), modes}
  end

  defp atat(memory = {memlist, memmap}, _context = %{ip: ip, base: base}, offset) do
    position =
      case at(modes(memory, ip), offset - 1, 0) do
        0 -> at(memlist, ip + offset)
        1 -> ip + offset
        2 -> base + at(memlist, ip + offset)
      end

    at(memlist, position, memmap[position] || 0)
  end

  def intlist_from_file(path) do
    File.read!(path)
    |> String.split(~r/[\s,]+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
