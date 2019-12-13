defmodule AsteroidGridTest do
  use ExUnit.Case

  test "it parses an input file" do
    grid = AsteroidGrid.parse("fixture-1.txt")
    assert AsteroidGrid.blank?(grid, {0, 0})
    assert AsteroidGrid.blank?(grid, {0, 1})
    assert AsteroidGrid.rock?(grid, {1, 0})
  end

  test "it detects the visible asteroids from each asteroid" do
    grid = AsteroidGrid.parse("fixture-2.txt")
    map = AsteroidGrid.visibility_map(grid)
    assert map[{1, 1}] == [{0, 0}, {2, 2}]
    assert map[{0, 0}] == [{1, 1}]
    assert map[{2, 2}] == [{1, 1}]
  end

  test "it detects invisible asteroids with the smallest integer steps" do
    grid = AsteroidGrid.parse("fixture-3.txt")
    map = AsteroidGrid.visibility_map(grid)
    assert map[{1, 1}] == [{0, 0}, {3, 3}]
    assert map[{0, 0}] == [{1, 1}]
    assert map[{3, 3}] == [{1, 1}]
  end

  test "it finds the position with best view" do
    assert AsteroidGrid.best_view("fixture-2.txt") == {{1, 1}, 2}
    assert AsteroidGrid.best_view("fixture-1.txt") == {{3, 4}, 8}
    assert AsteroidGrid.best_view("fixture-4.txt") == {{5, 8}, 33}
    assert AsteroidGrid.best_view("fixture-5.txt") == {{1, 2}, 35}
    assert AsteroidGrid.best_view("fixture-6.txt") == {{6, 3}, 41}
    assert AsteroidGrid.best_view("fixture-7.txt") == {{11, 13}, 210}
  end

  test "task 1" do
    assert AsteroidGrid.best_view("input.txt") == {{17, 22}, 276}
  end
end
