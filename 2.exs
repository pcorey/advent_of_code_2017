# http://adventofcode.com/2017/day/2

# Part one
System.argv
|> List.first
|> String.split("\n", trim: true)
|> Enum.map(fn
  row ->
    row
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.min_max
    |> (fn {min, max} -> max - min end).()
 end)
|> Enum.sum
|> IO.inspect

# Part two
defmodule Sheet do
  def process_input(input) do
    input
    |> List.first
    |> String.split("\n", trim: true)
    |> Enum.map(&process_row/1)
  end

  def checksum(rows) do
    rows
    |> Enum.map(&find_pair/1)
    |> Enum.map(&divide_pair/1)
    |> Enum.sum
  end

  defp process_row(row) do
    row
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp find_pair(row) do
    row
    |> Enum.map(&check_divisor(&1, row))
    |> Enum.reject(&Kernel.==(&1, []))
    |> List.first
    |> List.flatten
  end

  defp check_divisor(divisor, row) do
    Enum.intersperse(row, divisor) ++ [divisor]
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a | [b | []]] -> rem(a, b) == 0 && a != b end)
  end

  defp divide_pair([a | [b | []]]) do
    div(a, b)
  end
end

System.argv
|> Sheet.process_input
|> Sheet.checksum
|> IO.inspect
