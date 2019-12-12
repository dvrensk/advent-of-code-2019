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

  test "reading incomplete input" do
    assert Intcode.run([3, 0, 3, 1, 99], %{input: [33]}) ==
             (state = {:waiting, %{memory: [33, 0, 3, 1, 99], ip: 2, output: []}})

    assert Intcode.resume(state, %{input: [44]}).memory == [33, 44, 3, 1, 99]
  end

  test "writing output" do
    assert Intcode.run([4, 0, 4, 4, 99]).output == [4, 99]
  end

  test "immediate mode" do
    assert Intcode.run([1002, 4, 3, 4, 33]).memory == [1002, 4, 3, 4, 99]
  end

  test "handles negatives" do
    assert Intcode.run([1101, 100, -1, 4, 0]).memory == [1101, 100, -1, 4, 99]
  end

  test "opcode 8, eq" do
    program = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
    assert Intcode.run(program, %{input: [8]}).output == [1]
    assert Intcode.run(program, %{input: [9]}).output == [0]

    program = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
    assert Intcode.run(program, %{input: [8]}).output == [1]
    assert Intcode.run(program, %{input: [9]}).output == [0]
  end

  test "opcode 7, less than" do
    program = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
    assert Intcode.run(program, %{input: [5]}).output == [1]
    assert Intcode.run(program, %{input: [9]}).output == [0]

    program = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
    assert Intcode.run(program, %{input: [7]}).output == [1]
    assert Intcode.run(program, %{input: [8]}).output == [0]
  end

  test "opcodes 5 & 6, jnz & jz" do
    program = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
    assert Intcode.run(program, %{input: [123]}).output == [1]
    assert Intcode.run(program, %{input: [0]}).output == [0]

    program = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]
    assert Intcode.run(program, %{input: [123]}).output == [1]
    assert Intcode.run(program, %{input: [0]}).output == [0]
  end

  test "fixture 1" do
    intlist = Intcode.intlist_from_file("intcode-fixture-1.txt")
    assert Intcode.run(intlist, %{input: [0]}).output == [999]
    assert Intcode.run(intlist, %{input: [8]}).output == [1000]
    assert Intcode.run(intlist, %{input: [12345]}).output == [1001]
  end
end
