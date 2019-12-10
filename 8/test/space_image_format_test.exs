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

  test "it flattens layers with transparency" do
    layers = SpaceImageFormat.parse("0222112222120000", 2, 2)
    assert SpaceImageFormat.merge_down(layers) == [[0, 1], [1, 0]]
  end

  test "it solves part 2" do
    layers = SpaceImageFormat.parse(File.read!("input.txt"), 25, 6)

    ygryz = """
    8···8·88··888··8···88888·
    8···88··8·8··8·8···8···8·
    ·8·8·8····8··8··8·8···8··
    ··8··8·88·888····8···8···
    ··8··8··8·8·8····8··8····
    ··8···888·8··8···8··8888·
    """

    assert SpaceImageFormat.render(SpaceImageFormat.merge_down(layers)) == ygryz
  end
end
