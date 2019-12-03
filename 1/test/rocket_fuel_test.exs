defmodule RocketFuelTest do
  use ExUnit.Case

  test "for_weight" do
    assert RocketFuel.for_weight(12) == 2
    assert RocketFuel.for_weight(1969) == 654
    assert RocketFuel.for_weight(100_756) == 33583
  end

  test "for_file" do
    # assert RocketFuel.for_file("input.txt") == 3296269 # not including self
    assert RocketFuel.for_file("input.txt") == 4_941_547
  end

  test "for_weight_and_self" do
    assert RocketFuel.for_weight_and_self(12) == 2
    assert RocketFuel.for_weight_and_self(1969) == 966
    assert RocketFuel.for_weight_and_self(100_756) == 50346
  end
end
