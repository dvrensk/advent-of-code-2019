defmodule FlawedTxTest do
  use ExUnit.Case

  test "the factor pattern" do
    assert Enum.take(FlawedTx.factor_pattern(1), 5) == [1, 0, -1, 0, 1]
    assert Enum.take(FlawedTx.factor_pattern(2), 6) == [0, 1, 1, 0, 0, -1]
  end

  test "example 1, 1 phase" do
    assert FlawedTx.transform("12345678", 1) == "48226158"
  end

  test "example 1, 2 phases" do
    assert FlawedTx.transform("12345678", 2) == "34040438"
  end

  test "acceptance" do
    assert FlawedTx.transform8("80871224585914546619083218645595", 100) == "24176176"
    assert FlawedTx.transform8("19617804207202209144916044189917", 100) == "73745418"
    assert FlawedTx.transform8("69317163492948606335995924319873", 100) == "52432133"
  end

  test "part 1" do
    text = File.read!("input.txt")
    assert FlawedTx.transform8(text, 100) == "32002835"
  end
end
