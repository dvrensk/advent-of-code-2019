defmodule SpaceImageFormatTest do
  use ExUnit.Case

  test "it splits a string into layers" do
    assert SpaceImageFormat.parse("123456789012", 3, 2) == [
             [
               [1, 2, 3],
               [4, 5, 6]
             ],
             [
               [7, 8, 9],
               [0, 1, 2]
             ]
           ]
  end

  test "it solves part 1" do
    layer =
      SpaceImageFormat.parse(File.read!("input.txt"), 25, 6)
      |> Enum.min_by(&SpaceImageFormat.count_digit(&1, 0))

    assert SpaceImageFormat.count_digit(layer, 1) * SpaceImageFormat.count_digit(layer, 2) == 2684
  end
end
