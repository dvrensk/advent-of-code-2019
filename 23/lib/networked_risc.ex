defmodule NetworkedRisc do
  def start_many(code, count) do
    pids = for nic <- 0..(count - 1), do: {nic, start(code, nic)}
    loop(%{last_packet: nil, prev_sent_y: nil, idling: MapSet.new()}, pids)
  end

  def start(code, nic_id) do
    current = self()
    spawn(fn -> Intcode.run(code, %{input: [nic_id], network: {current, nic_id}}) end)
  end

  def loop(nat = %{idling: idling}, pids) do
    receive do
      {:idling, from_nic} ->
        case MapSet.member?(nat[:idling], from_nic) do
          true ->
            # IO.puts("same")
            loop(nat, pids)

          false ->
            idling = MapSet.put(idling, from_nic)

            if MapSet.size(idling) >= 50 && nat[:last_packet] do
              {0, pid0} = Enum.find(pids, fn {id, _} -> id == 0 end)
              send(pid0, {:from_network, nat[:last_packet]})
              # IO.puts("Restarting: #{inspect({:from_network, nat[:last_packet]})}")
              {_, y} = nat[:last_packet]

              case nat[:prev_sent_y] do
                ^y ->
                  {y, nat}

                _ ->
                  loop(
                    %{nat | prev_sent_y: y, idling: MapSet.new(), last_packet: nil},
                    pids
                  )
              end
            else
              # (for n <- 0..49, do: if MapSet.member?(idling, n), do: "#", else: "·")
              # |> Enum.join()
              # |> IO.puts()
              loop(%{nat | idling: idling}, pids)
            end
        end

      _pkt = {:packet, {255, x, y}, from_nic} ->
        # IO.inspect(_pkt)
        idling = MapSet.delete(idling, from_nic)

        %{nat | last_packet: {x, y}, idling: idling}
        |> loop(pids)

      _pkt = {:packet, {nic, x, y}, from_nic} when nic < 50 ->
        # IO.inspect(_pkt)
        Enum.find(pids, fn {id, _} -> id == nic end)
        |> elem(1)
        |> send({:from_network, {x, y}})

        idling =
          idling
          |> MapSet.delete(from_nic)
          |> MapSet.delete(nic)

        # (for n <- 0..49, do: if MapSet.member?(idling, n), do: "#", else: "·")
        # |> Enum.join()
        # |> IO.puts()
        %{nat | idling: idling}
        |> loop(pids)
    after
      1000 -> {:wtf, nat}
    end
  end
end
