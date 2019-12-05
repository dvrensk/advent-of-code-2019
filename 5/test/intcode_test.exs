defmodule IntcodeTest do
  use ExUnit.Case

  test "basic examples" do
    assert Intcode.run([1, 0, 0, 0, 99]).memory == [2, 0, 0, 0, 99]
    assert Intcode.run([2, 3, 0, 3, 99]).memory == [2, 3, 0, 6, 99]
    assert Intcode.run([2, 4, 4, 5, 99, 0]).memory == [2, 4, 4, 5, 99, 9801]
    assert Intcode.run([1, 1, 1, 4, 99, 5, 6, 0, 99]).memory == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end

  test "reading input" do
    assert Intcode.run([3, 0, 3, 1, 99], %{input: [33, 44]}).memory == [33, 44, 3, 1, 99]
  end

  test "writing output" do
    assert Intcode.run([4, 0, 4, 4, 99]).output == [4,99]
  end
end
