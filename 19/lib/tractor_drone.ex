defmodule TractorDrone do
  @left 70 / 100
  @right 88 / 100

  def find_square(n) do
    xy = guess(n)

    case best_in_line(n, xy) do
      nil -> better_below(n, xy)
      xy2 -> better_above(n, xy2)
    end
  end

  def best_in_line(n, {x, y}) do
    x2 = leftmost_on_line(y + n - 1, x)

    if affected?(x2 + n - 1, y) do
      {x2, y}
    end
  end

  def leftmost_on_line(y, x_hint) do
    leftmost(y, x_hint - 20)
  end

  def leftmost(y, x) do
    case affected?(x, y) do
      true -> x
      _ -> leftmost(y, x + 1)
    end
  end

  def better_above(n, {x, y}) do
    case best_in_line(n, {x, y - 1}) do
      nil -> {x, y}
      xy2 -> better_above(n, xy2)
    end
  end

  def better_below(n, {x, y}) do
    case best_in_line(n, {x, y + 1}) do
      nil -> better_below(n, {x, y + 1})
      xy2 -> xy2
    end
  end

  def guess(n) do
    # @left * (y + n) + n < @right * y
    # @left * y + @left * n + n < @right * y
    # @left * y + (@left + 1) * n < @right * y
    # (@left + 1) * n < @right * y - @left * y
    # (@left + 1) * n < (@right - @left) * y
    # (@left + 1) * n / (@right - @left) < y

    y = round((@left + 1) * (n - 1) / (@right - @left))
    x = round(@left * (y + n))
    {x, y}
  end

  def scan(list) do
    code = load_code()
    Enum.filter(list, fn {x, y} -> affected?(code, x, y) end)
  end

  def affected?(x, y) do
    load_code()
    |> affected?(x, y)
  end

  def affected?(code, x, y) do
    %{output: [output]} = Intcode.run(code, %{input: [x, y]})

    case output do
      0 -> false
      1 -> true
    end
  end

  def load_code(path \\ "input.txt") do
    Intcode.intlist_from_file(path)
  end

  def print_grid(positions) do
    IO.puts("################")

    render(positions)
    |> Enum.each(&IO.puts(&1))

    IO.puts("################")
  end

  def render(positions) do
    {x_min, x_max} = Enum.map(positions, &elem(&1, 0)) |> Enum.min_max()
    {y_min, y_max} = Enum.map(positions, &elem(&1, 1)) |> Enum.min_max()
    render_line(y_min, y_max, x_min..x_max, MapSet.new(positions), [])
  end

  def render_line(y, y_max, _, _grid, ack) when y > y_max, do: Enum.reverse(ack)

  def render_line(y, y_max, x_range, positions, ack) do
    line =
      x_range
      |> Enum.map(fn x ->
        if MapSet.member?(positions, {x, y}), do: "8", else: "·"
      end)
      |> Enum.join()

    render_line(y + 1, y_max, x_range, positions, [line | ack])
  end
end
