defmodule IntcodeTest do
  use ExUnit.Case

  test "basic examples" do
    assert Intcode.run([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
    assert Intcode.run([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
    assert Intcode.run([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
    assert Intcode.run([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end

  # test "run with 1202" do
  #   input =
  #     File.read!("input.txt")
  #     |> String.split(",")
  #     |> Enum.map(&String.to_integer/1)
  #     |> List.replace_at(1, 12)
  #     |> List.replace_at(2, 2)
  #   assert hd(Intcode.run(input)) == 3895705
  # end

  test "run with 1202" do
    assert hd(Intcode.run(Intcode.well_known_program(12, 2))) == 3_895_705
  end

  test "find noun+verb for 19690720" do
    assert Intcode.find(19_690_720) == 6417
  end
end
