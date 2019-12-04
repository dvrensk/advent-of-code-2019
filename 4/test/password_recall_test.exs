defmodule PasswordRecallTest do
  use ExUnit.Case

  test "generates 122345" do
    assert PasswordRecall.in_range(122_345..122_345) == [122_345]
  end

  test "rejects 223450" do
    assert PasswordRecall.in_range(223_450..223_450) == []
  end

  test "at least one true double" do
    assert PasswordRecall.in_range(123_339..123_344) == [123_344]
  end

  test "finds the candidates for the second quiz" do
    assert Enum.count(PasswordRecall.in_range(145_852..616_942)) == 1192
  end
end
