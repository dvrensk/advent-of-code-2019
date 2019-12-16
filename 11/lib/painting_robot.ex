defmodule PaintingRobot do
  defstruct(position: {0, 0}, brain: nil, grid: %{}, heading: :up)

  def new(brain \\ nil) do
    %PaintingRobot{brain: brain}
  end

  def run(robot) do
    case awake?(robot.brain) do
      true ->
        run(step(robot))
      _ ->
        robot
    end
  end

  def awake?({:list, list}), do: not(Enum.empty?(list))
  def awake?({:waiting, _}), do: true
  def awake?(%{output: _}), do: false

  def step(robot) do
    {{dye, swivel}, new_brain} =
      ask(robot.brain, colour_number(colour_of(robot.position, robot.grid)))

    grid = paint(robot.grid, robot.position, dye)
    heading = pivot(robot.heading, swivel)

    %{
      robot
      | brain: new_brain,
        heading: heading,
        position: advance(heading, robot.position),
        grid: grid
    }
  end

  @colours [black: 0, white: 1]

  def colour_number(name), do: elem(List.keyfind(@colours, name, 0), 1)
  def colour_name(number), do: elem(List.keyfind(@colours, number, 1), 0)

  def swivel_name(0), do: :left
  def swivel_name(1), do: :right

  def ask({:list, [{colour, dye, swivel} | rest]}, colour) do
    {
      {colour_name(dye), swivel_name(swivel)},
      {:list, rest}
    }
  end
  def ask(intcode = {:waiting, state}, colour) do
    {{dye, swivel}, new_state} = resume_intcode(state, colour)
    {
      {colour_name(dye), swivel_name(swivel)},
      new_state
    }
  end

  def resume_intcode(old_state, colour) do
    case Intcode.resume({:waiting, old_state}, %{input: [colour]}) do
      {:waiting, state} ->
        output = state.output
        {List.to_tuple(output), {:waiting, %{state | output: []}}}
      final_state ->
        output = final_state.output
        {List.to_tuple(output), final_state}
    end
  end

  def paint(grid, position, dye) do
    case Map.get(grid, position) do
      ^dye ->
        grid

      _ ->
        Map.put(grid, position, dye)
    end
  end

  @cardinal_directions [:up, :right, :down, :left]
  def pivot(current, swivel) do
    index = Enum.find_index(@cardinal_directions, fn e -> e == current end)

    adjusted =
      case swivel do
        :left -> index - 1
        :right -> index + 1
      end

    Enum.at(@cardinal_directions, Integer.mod(adjusted, 4))
  end

  def advance(direction, {x, y}) do
    case direction do
      :up -> {x, y + 1}
      :down -> {x, y - 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

  def colour_of(position, grid) do
    Map.get(grid, position) || :black
  end
end
