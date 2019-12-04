defmodule WireGridTest do
  use ExUnit.Case

  test "two simple wires" do
    assert WireGrid.wire_from_text("R1") == [{0, 0}, {1, 0}]
    assert WireGrid.wire_from_text("R1,U1") == [{0, 0}, {1, 0}, {1, 1}]
  end

  test "example manhattan distances" do
    assert WireGrid.manhattan_distance("R8,U5,L5,D3", "U7,R6,D4,L4") == 6

    assert WireGrid.manhattan_distance(
             "R75,D30,R83,U83,L12,D49,R71,U7,L72",
             "U62,R66,U55,R34,D71,R55,D58,R83"
           ) == 159

    assert WireGrid.manhattan_distance(
             "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
             "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
           ) == 135
  end

  test "quiz 1" do
    assert WireGrid.manhattan_from_file("input.txt") == 731
  end
end
