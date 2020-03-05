defmodule Fourteen do
  def ore_for_one_fuel(input) do
    input
    |> parse_input()
    |> solve_for_one_fuel()
  end

  def solve_for_one_fuel(rules = %{"FUEL" => {1, i_wish_i_had}}) do
    solve(i_wish_i_had, rules)
  end

  def solve(i_wish_i_had, rules) do
    if done(i_wish_i_had) do
      i_wish_i_had["ORE"]
    else
      i_wish_i_had
      |> Enum.map(fn
        {"ORE", amt} ->
          %{"ORE" => amt}
        {any, amt} when amt < 1 ->
          %{any => amt}
        {chem, needed_amt} -> 
          {output_amt, ingredients} = Map.get(rules, chem)
          batches = ceil(needed_amt / output_amt)
          Map.new(ingredients, fn {ingr, amt} -> {ingr, amt * batches} end)
          |> Map.put(chem, -(batches * output_amt - needed_amt))
       end)
      |> Enum.reduce(fn m1, m2 ->
          Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end)
        end)
      |> solve(rules)
    end
  end

  def done(i_wish_i_had) do
    i_wish_i_had
    |> Map.drop(["ORE"])
    |> Enum.all?(fn {_, v} -> v < 1 end)
  end

  def parse_input(input) do
    # Let's get to this:
    # %{C -> {1, %{"A" => 7, "B" => 1}}}
    # %{"FUEL" => {1, %{"AB" => 2, "BC" => 3, "CA" => 4}}}
    input
    |> String.split("\n", trim: true)
    |> Map.new(&parse_line/1)
  end

  def parse_line(line) do
    # "7 A, 1 B => 1 C"
    # ["7 A, 1 B", "1 C"]
    [recipe, result] = line |> String.split(" => ")
    ingredients = recipe
      |> String.split(", ")
      |> Map.new(&parse_quantified_chemical/1)
    {chem, quantity} = parse_quantified_chemical(result)
    {chem, {quantity, ingredients}}
  end

  def parse_quantified_chemical(quantified_chemical) do
    [quantity_string, chem] =
      quantified_chemical
      |> String.split(" ")
    {chem, String.to_integer(quantity_string)}
  end
end
