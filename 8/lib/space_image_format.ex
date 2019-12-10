defmodule SpaceImageFormat do
  def parse(string, width, height) do
    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Stream.chunk_every(width)
    |> Stream.chunk_every(height)
    |> Enum.to_list()
  end

  def merge_down([top | rest]), do: merge_down(top, rest)

  def merge_down(merged, []), do: merged

  def merge_down(a, [b | rest]) do
    width = length(hd(a))

    merge(List.flatten(a), List.flatten(b), [])
    |> Stream.chunk_every(width)
    |> Enum.to_list()
    |> merge_down(rest)
  end

  def merge([], [], ack), do: Enum.reverse(ack)
  def merge([2 | as], [b | bs], ack), do: merge(as, bs, [b | ack])
  def merge([a | as], [_ | bs], ack), do: merge(as, bs, [a | ack])

  def render(layer) do
    layer
    |> Enum.map(fn row -> row |> Enum.map(&Integer.to_string/1) |> Enum.join() end)
    |> Enum.join("\n")
    |> String.replace("1", "8")
    |> String.replace("0", "·")
    |> (fn s -> s <> "\n" end).()
  end

  def count_digit(layer, digit) do
    List.flatten(layer)
    |> Enum.count(fn e -> e == digit end)
  end
end
