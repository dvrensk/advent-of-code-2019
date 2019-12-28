defmodule NetworkedRiscTest do
  use ExUnit.Case

  test "it sends packets to the network" do
    code = [104, 10, 104, 20, 104, 30, 99]
    pid = NetworkedRisc.start(code, 5)
    packet =
      receive do
        {:packet, packet, ^pid} -> packet
      after
        500 -> :no_message
      end
    assert packet == {10,20,30}
  end

  test "it receives packets from the network" do
    code = [
      3,999,
      1005,999,0,
      4,999,
      3,999,
      4,999,
      3,999,
      4,999,
      99
    ]

    # assert Intcode.run(code, %{input: [5,-1,-1,-1,0,11,-1,-1,-1]}).output == [0,11,-1]
    pid = NetworkedRisc.start(code, 5)
    send(pid, {:from_network, {0,11}})
    packet =
      receive do
        {:packet, packet, ^pid} -> packet
      after
        500 -> :no_message
      end
    assert packet == {0,11,-1}
  end

  test "it runs 50 computers" do
    code = Intcode.intlist_from_file("input.txt")
    result = NetworkedRisc.start_many(code, 50)
    assert result == {36, {255, 42283, 17286}}
  end
end
