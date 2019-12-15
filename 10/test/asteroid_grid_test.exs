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

  test "it calculates radians from 12 o'clock" do
    ds = [
      {0, -1},
      {1, -1},
      {1, 0},
      {1, 1},
      {0, 1},
      {-1, 1},
      {-1, 0},
      {-1, -1}
    ]

    decorated = Enum.map(ds, fn {dx, dy} -> {{dx, dy}, AsteroidGrid.rad(dx, dy)} end)
    assert Enum.sort_by(decorated, fn {_, rad} -> rad end) == decorated
  end

  test "it collects asteroids by angle, order by closeness" do
    grid = AsteroidGrid.parse("fixture-8.txt")

    assert AsteroidGrid.group_by(grid, {1, 2}) == %{
             0.0 => [{1, 1}, {1, 0}],
             (:math.pi() / 2) => [{3, 2}],
             (3 * :math.pi() / 2) => [{0, 2}]
           }
  end

  test "vape in order" do
    assert AsteroidGrid.vape_in_order("fixture-8.txt", {1, 2}) == [{1, 1}, {3, 2}, {0, 2}, {1, 0}]

    list = AsteroidGrid.vape_in_order("fixture-7.txt", {11, 13})
    # Text list is 1-based
    list = [0 | list]
    # The 1st asteroid to be vaporized is at 11,12.
    assert Enum.at(list, 1) == {11, 12}
    # The 2nd asteroid to be vaporized is at 12,1.
    assert Enum.at(list, 2) == {12, 1}
    # The 3rd asteroid to be vaporized is at 12,2.
    assert Enum.at(list, 3) == {12, 2}
    # The 10th asteroid to be vaporized is at 12,8.
    assert Enum.at(list, 10) == {12, 8}
    # The 20th asteroid to be vaporized is at 16,0.
    assert Enum.at(list, 20) == {16, 0}
    # The 50th asteroid to be vaporized is at 16,9.
    assert Enum.at(list, 50) == {16, 9}
    # The 100th asteroid to be vaporized is at 10,16.
    assert Enum.at(list, 100) == {10, 16}
    # The 199th asteroid to be vaporized is at 9,6.
    assert Enum.at(list, 199) == {9, 6}
    # The 200th asteroid to be vaporized is at 8,2.
    assert Enum.at(list, 200) == {8, 2}
    # The 201st asteroid to be vaporized is at 10,9.
    assert Enum.at(list, 201) == {10, 9}
    # The 299th and final asteroid to be vaporized is at 11,1.
    assert Enum.at(list, 299) == {11, 1}
    # The 299th and final asteroid to be vaporized is at 11,1.
    assert Enum.at(list, 300) == nil
  end

  test "task 2" do
    list = AsteroidGrid.vape_in_order("input.txt", {17, 22})
    # Task is 1-based
    list = [0 | list]
    assert Enum.at(list, 200) == {13, 21}
  end
end
