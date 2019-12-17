defmodule Nbody do
  def new(string) do
    String.split(string, ~r/\n/, trim: true)
    |> Enum.map(fn line ->
      pos =
        Regex.scan(~r/[-0-9]+/, line)
        |> Enum.map(fn [s] -> String.to_integer(s) end)
        |> List.to_tuple()

      {pos, {0, 0, 0}}
    end)
  end

  def step_several(0, moons), do: moons

  def step_several(n, moons) do
    new_moons = step(moons)
    step_several(n - 1, new_moons)
  end

  def step(moons) do
    moons
    |> Enum.map(&apply_gravity(&1, moons -- [&1]))
    |> Enum.map(&apply_velocity(&1))
  end

  def apply_gravity(moon, []), do: moon

  def apply_gravity({pos1, velocity}, [{pos2, _} | others]) do
    new_velocity =
      [pos1, pos2, velocity]
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.zip()
      |> Enum.map(fn {d1, d2, v} ->
        case d1 - d2 do
          0 -> v
          n when n < 0 -> v + 1
          n when n > 0 -> v - 1
        end
      end)
      |> List.to_tuple()

    apply_gravity({pos1, new_velocity}, others)
  end

  def apply_velocity({pos, velocity}) do
    new_pos =
      [pos, velocity]
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.zip()
      |> Enum.map(fn {d, v} -> d + v end)
      |> List.to_tuple()

    {new_pos, velocity}
  end

  def render(moons, ack \\ [])
  def render([], ack), do: Enum.join(Enum.reverse(["" | ack]), "\n")

  def render([{{xp, yp, zp}, {xv, yv, zv}} | rest], ack) do
    render(rest, ["pos=<x=#{xp}, y=#{yp}, z=#{zp}>, vel=<x=#{xv}, y=#{yv}, z=#{zv}>" | ack])
  end

  def render_energy(moons, ack \\ [])

  def render_energy([], ack) do
    energies = Enum.reverse(ack) |> Enum.map(&elem(&1, 1))
    total = "Sumoftotalenergy: #{Enum.join(energies, "+")}=#{Enum.sum(energies)}"
    Enum.join(Enum.reverse(["", total | Enum.map(ack, &elem(&1, 0))]), "\n")
  end

  def render_energy([{{xp, yp, zp}, {xv, yv, zv}} | rest], ack) do
    [xp, yp, zp, xv, yv, zv] = Enum.map([xp, yp, zp, xv, yv, zv], &abs/1)
    pot = xp + yp + zp
    kin = xv + yv + zv

    string =
      "pot: #{xp}+#{yp}+#{zp}=#{pot}; kin: #{xv}+#{yv}+#{zv}=#{kin}; total: #{pot}*#{kin}=#{
        pot * kin
      }"

    render_energy(rest, [{string, pot * kin} | ack])
  end
end
