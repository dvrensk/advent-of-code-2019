defmodule SpaceImageFormat do
  def parse(string, width, height) do
    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Stream.chunk_every(width)
    |> Stream.chunk_every(height)
    |> Enum.to_list()
  end

  def count_digit(layer, digit) do
    List.flatten(layer)
    |> Enum.count(fn e -> e == digit end)
  end
end
