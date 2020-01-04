defmodule BlindDroidTest do
  use ExUnit.Case

  test "it walks one step" do
    droid = BlindDroid.start()
    {_, result} = BlindDroid.walk(droid, 4)
    assert result == 1
  end

  test "it bounces" do
    droid = BlindDroid.start()
    {_, result} = BlindDroid.walk(droid, 3)
    assert result == 0
  end

  test "it walks back and forth" do
    droid = BlindDroid.start()
    {d2, result} = BlindDroid.walk(droid, 4)
    assert result == 1
    {_, result} = BlindDroid.walk(d2, 3)
    assert result == 1
  end

  test "running 5 iterations should give me knowledge of 6 cells (5 + origo)" do
    {grid, _todo} = BlindDroid.chart(5)
    assert map_size(grid) == 6
  end

  test "prints a map of many iterations" do
    {grid, _todo} = BlindDroid.chart(5000)
    # BlindDroid.print_grid(grid)
    assert map_size(grid) == 1 + 1658
  end

  test "finds the shortest path with digraph (task 1)" do
    path = BlindDroid.shortest_path()
    assert length(tl(path)) == 424
  end

  test "finds the number of steps to fill the entire module with oxygen (task 2)" do
    assert length(tl(BlindDroid.oxygenise())) == 446
  end
end
