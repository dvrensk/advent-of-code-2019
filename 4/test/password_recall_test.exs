defmodule PasswordRecallTest do
  use ExUnit.Case

  test "generates 122345" do
    assert PasswordRecall.in_range(122_345..122_345) == [122_345]
  end

  test "rejects 223450" do
    assert PasswordRecall.in_range(223_450..223_450) == []
  end

  test "at least one double" do
    assert PasswordRecall.in_range(123_455..123_456) == [123_455]
  end

  test "finds the candidates for the quiz" do
    assert Enum.count(PasswordRecall.in_range(145_852..616_942)) == 1767
  end
end
