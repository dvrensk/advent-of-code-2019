defmodule ArcadeTest do
  use ExUnit.Case

  test "it runs the game" do
    [0, 0, 1 | _] = Arcade.run().output
  end

  test "renders the final screen, sort of" do
    assert Map.values(Arcade.final_map()) |> Enum.count(fn a -> a == 2 end) == 361
  end
end
