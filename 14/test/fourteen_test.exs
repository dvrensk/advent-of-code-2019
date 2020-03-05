defmodule FourteenTest do
  use ExUnit.Case
  doctest Fourteen

  test "solves example 1" do
    input = """
    10 ORE => 10 A
    1 ORE => 1 B
    7 A, 1 B => 1 C
    7 A, 1 C => 1 D
    7 A, 1 D => 1 E
    7 A, 1 E => 1 FUEL
    """

    assert Fourteen.ore_for_one_fuel(input) == 31
  end

  test "solves example 2" do
    input = """
    9 ORE => 2 A
    8 ORE => 3 B
    7 ORE => 5 C
    3 A, 4 B => 1 AB
    5 B, 7 C => 1 BC
    4 C, 1 A => 1 CA
    2 AB, 3 BC, 4 CA => 1 FUEL
    """

    assert Fourteen.ore_for_one_fuel(input) == 165
  end

  test "solves main task" do
    assert Fourteen.ore_for_one_fuel(File.read!("input.txt")) == 654909
  end
end
