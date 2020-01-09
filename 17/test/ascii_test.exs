defmodule AsciiTest do
  use ExUnit.Case

  @tag :diagnostic
  test "it outputs the starting scene" do
    IO.puts("")
    IO.puts(Ascii.run().output)
  end

  test "maps the grid" do
    grid = Ascii.grid()
    assert grid[{26, 2}]
    assert grid[{26+1, 2}]
    assert grid[{26-1, 2}]
    assert grid[{26, 2+1}]
    assert grid[{26, 2-1}]
    assert grid[{22, 6}]
  end

  test "it finds the intersections" do
    intersections = Ascii.intersections()
    assert Enum.member?(intersections, {26, 2})
    assert Enum.member?(intersections, {22, 6})
    assert List.foldl(intersections, 0, fn {x,y}, acc -> acc + x * y end) == 2660
  end
end
