defmodule NetworkedRisc do
  def start_many(code, count) do
    pids = for nic <- (0..(count-1)), do: {nic, start(code, nic)}
    loop(pids)
  end

  def start(code, nic_id) do
    current = self()
    spawn(fn -> Intcode.run(code, %{input: [nic_id], network: current}) end)
  end

  def loop(pids) do
    receive do
      _pkt = {:packet, {nic,x,y}, _pid} when nic < 50 ->
        # IO.inspect(pkt)
        Enum.find(pids, fn {id, _} -> id == nic end)
        |> elem(1)
        |> send({:from_network, {x,y}})
        loop(pids)
      {:packet, packet, from_pid} ->
        nic =
          Enum.find(pids, fn {_id, pid} -> pid == from_pid end)
          |> elem(0)
        {nic, packet}
    after
      5000 -> :no_message
    end
  end
end
