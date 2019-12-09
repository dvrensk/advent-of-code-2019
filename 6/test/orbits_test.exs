defmodule OrbitsTest do
  use ExUnit.Case

  test "counting with only direct orbits" do
    assert Orbits.count(File.read!("fixture-2.txt")) == 2
  end

  test "counting with direct and indirect orbits" do
    assert Orbits.count(File.read!("fixture-3.txt")) == 3
  end

  test "given example" do
    assert Orbits.count(File.read!("fixture-1.txt")) == 42
  end

  test "task 1" do
    assert Orbits.count(File.read!("input.txt")) == 110_190
  end

  #                           YOU
  #                          /
  #         G - H       J - K - L
  #        /           /
  # COM - B - C - D - E - F
  #                \
  #                 I - SAN
  test "orbital transfers, small example" do
    assert Orbits.transfer(File.read!("fixture-4.txt"), "YOU", "SAN") ==
             {["K", "J", "E", "D"], ["I"]}

    assert Orbits.transfer_count(File.read!("fixture-4.txt"), "YOU", "SAN") == 4
  end

  test "task 2" do
    assert Orbits.transfer_count(File.read!("input.txt"), "YOU", "SAN") == 343
  end
end
