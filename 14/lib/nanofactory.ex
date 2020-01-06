defmodule Nanofactory do
  @fuel "FUEL"
  @ore "ORE"
  @max 1_000_000_000_000

  def solve(path) do
    rules = parse(path)
    accounts = solve(%{@fuel => -1}, rules)
    {-accounts[@ore], @ore}
  end

  def maximise(path) do
    rules = parse(path)
    accounts = solve(%{@fuel => -1}, rules)
    unit_cost = -accounts[@ore]
    solve_until_depleted(unit_cost, 1, accounts, rules)
  end

  def solve_until_depleted(unit_cost, so_far, accounts, rules) do
    budget =
      case div(@max + accounts[@ore], unit_cost) do
        0 -> 1
        n when n > 0 -> n
      end

    accounts =
      Map.put(accounts, @fuel, -budget)
      |> solve(rules)

    if accounts[@ore] < -@max do
      so_far
    else
      solve_until_depleted(unit_cost, so_far + budget, accounts, rules)
    end
  end

  def solve(accounts, rules) do
    case negative(accounts) do
      nil ->
        accounts

      {output, balance} ->
        {output_count, inputs} = rules[output]

        factor =
          case div(-balance, output_count) do
            0 -> 1
            n -> n
          end

        inputs
        |> List.foldl(accounts, fn {name, n}, acc ->
          Map.update(acc, name, -n * factor, fn old -> old - n * factor end)
        end)
        |> Map.update!(output, fn old -> old + output_count * factor end)
        |> solve(rules)
    end
  end

  def negative(accounts) do
    accounts
    |> Enum.find(fn {name, n} -> name != @ore && n < 0 end)
  end

  def parse(path) do
    File.stream!(path)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  def parse_line(line) do
    [{output, output_count} | inputs] =
      Regex.scan(~r/(\d+) ([A-Z]+)/, line, capture: :all_but_first)
      |> Enum.map(fn [n, name] -> {name, String.to_integer(n)} end)
      |> Enum.reverse()

    {output, {output_count, Enum.reverse(inputs)}}
  end
end
