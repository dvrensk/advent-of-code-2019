defmodule Nanofactory do
  def solve(path) do
    rules = parse(path)
    solve(%{"FUEL" => -1}, rules)
  end

  def solve(accounts, rules) do
    case negative(accounts) do
      nil ->
        {-accounts["ORE"], "ORE"}

      {output, _balance} ->
        {output_count, inputs} = rules[output]

        inputs
        |> List.foldl(accounts, fn {name, n}, acc ->
          Map.update(acc, name, -n, fn old -> old - n end)
        end)
        |> Map.update!(output, fn old -> old + output_count end)
        |> solve(rules)
    end
  end

  def negative(accounts) do
    accounts
    |> Enum.find(fn {name, n} -> name != "ORE" && n < 0 end)
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
