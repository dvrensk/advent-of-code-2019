defmodule AmplifierTest do
  use ExUnit.Case

  @pgm_1 [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]
  @pgm_2 "3,23,3,24,1002,24,10,24,1002,23,-1,23,
      101,5,23,23,1,24,23,23,4,23,99,0,0"
  @pgm_3 "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
      1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

  test "it runs an amplifier chain" do
    assert Amplifier.run(@pgm_1, [4, 3, 2, 1, 0]) == 43210
  end

  test "it finds the weights that gives maximum output" do
    assert Amplifier.find_for(@pgm_1) == {[4, 3, 2, 1, 0], 43210}
    assert Amplifier.find_for(@pgm_2) == {[0, 1, 2, 3, 4], 54321}
    assert Amplifier.find_for(@pgm_3) == {[1, 0, 4, 3, 2], 65210}
  end

  test "it solves part 1" do
    assert Amplifier.find_for(File.read!("input.txt")) == {[3, 2, 4, 0, 1], 440_880}
  end

  @pgm_4 "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
    27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
  @pgm_5 "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
    -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
    53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"

  test "it runs an amplifier chain with feedback" do
    assert Amplifier.run_with_feedback(Amplifier.parse(@pgm_4), [9, 8, 7, 6, 5]) == 139_629_729
    assert Amplifier.run_with_feedback(Amplifier.parse(@pgm_5), [9, 7, 8, 5, 6]) == 18216
  end

  test "it solves part 2" do
    assert Amplifier.find_with_feedback(File.read!("input.txt")) == {[5, 7, 9, 6, 8], 3_745_599}
  end
end
