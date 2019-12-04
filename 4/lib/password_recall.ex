defmodule PasswordRecall do
  def in_range(range) do
    range
    |> decorate()
    |> only_increasing()
    |> at_least_one_double()
    |> remove_decoration()
  end

  defp decorate(numbers) do
    Enum.map(numbers, fn a -> {a, Integer.digits(a)} end)
  end

  defp only_increasing(numbers) do
    numbers
    |> Enum.reject(fn {_, digits} -> decreasing_sequence?(digits) end)
  end

  defp decreasing_sequence?([_]), do: false
  defp decreasing_sequence?([a, b | _]) when a > b, do: true
  defp decreasing_sequence?([_ | tail]), do: decreasing_sequence?(tail)

  defp at_least_one_double(numbers) do
    numbers
    |> Enum.filter(fn {_, digits} -> at_least_one_double?(digits) end)
  end

  defp at_least_one_double?([_]), do: false
  defp at_least_one_double?([a, a | _]), do: true
  defp at_least_one_double?([_ | tail]), do: at_least_one_double?(tail)

  defp remove_decoration(numbers) do
    Enum.map(numbers, fn {a, _digits} -> a end)
  end
end
