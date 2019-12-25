defmodule TractorDroneTest do
  use ExUnit.Case

  test "knows whether a position is affected by the tractor beam" do
    assert TractorDrone.affected?(0, 0) == true
    assert TractorDrone.affected?(9, 0) == false
  end

  test "it calculates task 1" do
    affected =
      (for x <- 0..49, y <- 0..49, do: {x, y})
      |> TractorDrone.scan()

    # TractorDrone.print_grid(affected)
    assert length(affected) == 229
  end

  # test "it calculates line 100" do
  #   affected =
  #     (for x <- 0..100, y <- [0,50,100], do: {x, y})
  #     |> TractorDrone.scan()
  #   count = length(affected)
  #   TractorDrone.print_grid(affected)
  #   assert count == 229
  # end

  test "it finds the start of a 3x3 square" do
    assert TractorDrone.find_square(3) == {16, 21}
  end

  test "it finds the start of a 4x4 square" do
    assert TractorDrone.find_square(4) == {23, 30}
  end

  test "it finds the start of a 5x5 square" do
    assert TractorDrone.find_square(5) == {30, 39}
  end

  test "it finds the start of a 100x100 square" do
    assert TractorDrone.find_square(100) == {695, 903}
  end
end
