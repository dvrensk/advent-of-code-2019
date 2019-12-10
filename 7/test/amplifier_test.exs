defmodule AmplifierTest do
  use ExUnit.Case

  @pmg_one [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]
  @pgm_two "3,23,3,24,1002,24,10,24,1002,23,-1,23,
      101,5,23,23,1,24,23,23,4,23,99,0,0"
  @pgm_three "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
      1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

  test "it runs an amplifier chain" do
    assert Amplifier.run(@pmg_one, [4, 3, 2, 1, 0]) == 43210
  end

  test "it finds the weights that gives maximum output" do
    assert Amplifier.find_for(@pmg_one) == {[4, 3, 2, 1, 0], 43210}
    assert Amplifier.find_for(@pgm_two) == {[0, 1, 2, 3, 4], 54321}
    assert Amplifier.find_for(@pgm_three) == {[1, 0, 4, 3, 2], 65210}
  end

  test "it solves part 1" do
    assert Amplifier.find_for(File.read!("input.txt")) == {[3, 2, 4, 0, 1], 440_880}
  end
end
