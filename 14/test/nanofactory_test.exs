defmodule NanofactoryTest do
  use ExUnit.Case

  test "it parses a rule set" do
    rules = Nanofactory.parse("fixture-1.txt")
    assert rules["A"] == {10, [{"ORE", 10}]}
    assert rules["FUEL"] == {1, [{"A", 7}, {"E", 1}]}
  end

  test "it solves examples" do
    assert Nanofactory.solve("fixture-1.txt") == {31, "ORE"}
    assert Nanofactory.solve("fixture-2.txt") == {165, "ORE"}
    assert Nanofactory.solve("fixture-3.txt") == {13312, "ORE"}
    assert Nanofactory.solve("fixture-4.txt") == {180_697, "ORE"}
    assert Nanofactory.solve("fixture-5.txt") == {2_210_736, "ORE"}
  end

  test "it solves the puzzle (task 1)" do
    assert Nanofactory.solve("input.txt") == {387_001, "ORE"}
  end

  test "with 1 trillion ore" do
    assert Nanofactory.maximise("fixture-3.txt") == 82_892_753
    assert Nanofactory.maximise("fixture-4.txt") == 5_586_022
    assert Nanofactory.maximise("fixture-5.txt") == 460_664
  end

  test "it solves the puzzle for 1 trillion (task 2)" do
    assert Nanofactory.maximise("input.txt") == 3_412_429
  end
end
