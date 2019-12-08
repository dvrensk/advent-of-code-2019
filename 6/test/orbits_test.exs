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
end
