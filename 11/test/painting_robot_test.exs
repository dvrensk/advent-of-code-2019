defmodule PaintingRobotTest do
  use ExUnit.Case

  test "a newly started robot remember where it's been" do
    robot = PaintingRobot.new()
    assert robot.position == {0, 0}
  end

  test "stepping like the example" do
    robot =
      PaintingRobot.new(
        {:list,
         [
           {0, 1, 0},
           {0, 0, 0},
           {0, 1, 0},
           {0, 1, 0},
           {1, 0, 1},
           {0, 1, 0},
           {0, 1, 0}
         ]}
      )

    robot = PaintingRobot.step(robot)
    assert robot.grid == %{{0, 0} => :white}
    robot = PaintingRobot.step(robot)
    assert robot.grid == %{{0, 0} => :white, {-1, 0} => :black}
    robot = PaintingRobot.step(robot)
    assert robot.grid == %{{0, 0} => :white, {-1, 0} => :black, {-1, -1} => :white}
    robot = PaintingRobot.step(robot)

    assert robot.grid == %{
             {0, 0} => :white,
             {-1, 0} => :black,
             {-1, -1} => :white,
             {0, -1} => :white
           }

    robot = PaintingRobot.step(robot)

    assert robot.grid == %{
             {0, 0} => :black,
             {-1, 0} => :black,
             {-1, -1} => :white,
             {0, -1} => :white
           }

    robot = PaintingRobot.step(robot)

    assert robot.grid == %{
             {0, 0} => :black,
             {-1, 0} => :black,
             {-1, -1} => :white,
             {0, -1} => :white,
             {1, 0} => :white
           }

    robot = PaintingRobot.step(robot)

    assert robot.grid == %{
             {0, 0} => :black,
             {-1, 0} => :black,
             {-1, -1} => :white,
             {0, -1} => :white,
             {1, 0} => :white,
             {1, 1} => :white
           }
  end

  test "it stops running at the end of the program" do
    robot =
      PaintingRobot.new(
        {:list,
         [
           {0, 1, 0},
           {0, 0, 0},
           {0, 1, 0},
           {0, 1, 0},
           {1, 0, 1}
         ]}
      )

    robot = PaintingRobot.run(robot)
    assert robot.grid == %{
             {0, 0} => :black,
             {-1, 0} => :black,
             {-1, -1} => :white,
             {0, -1} => :white
           }
  end

  test "it runs an Intcode program (task 1)" do
    brain = Intcode.run(Intcode.intlist_from_file("input.txt"))
    robot = PaintingRobot.new(brain)
    robot = PaintingRobot.run(robot)
    assert map_size(robot.grid) == 2141
  end
end
