defmodule PasswordRecall do
  def in_range(range) do
    range
    |> decorate()
    |> Enum.reject(fn {_, digits} -> decreasing_sequence?(digits) end)
    |> Enum.filter(fn {_, digits} -> at_least_one_true_double?(digits) end)
    |> remove_decoration()
  end

  defp decorate(numbers) do
    Enum.map(numbers, fn a -> {a, Integer.digits(a)} end)
  end

  defp decreasing_sequence?([_]), do: false
  defp decreasing_sequence?([a, b | _]) when a > b, do: true
  defp decreasing_sequence?([_ | tail]), do: decreasing_sequence?(tail)

  defp at_least_one_true_double?([]), do: false

  defp at_least_one_true_double?([a, a, a | tail]) do
    tail
    |> Enum.drop_while(fn x -> x == a end)
    |> at_least_one_true_double?()
  end

  defp at_least_one_true_double?([a, a | _]), do: true
  defp at_least_one_true_double?([_ | tail]), do: at_least_one_true_double?(tail)

  defp remove_decoration(numbers) do
    Enum.map(numbers, fn {a, _digits} -> a end)
  end
end
