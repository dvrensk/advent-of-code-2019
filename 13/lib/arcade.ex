defmodule Arcade do
  def final_map() do
    run().output
    |> Enum.chunk_every(3)
    |> Map.new(fn [x, y, a] -> {{x, y}, a} end)
  end

  def run() do
    Intcode.intlist_from_file("input.txt")
    |> Intcode.run()
  end
end
