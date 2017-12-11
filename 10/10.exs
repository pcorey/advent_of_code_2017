defmodule KnotHash do
  def hash(input) do
    input
    |> parse
    |> Enum.reduce({0, 0, Enum.to_list(0..255)}, &knot/2)
    |> elem(2)
  end

  defp parse(input) do
    input
    |> String.split(~r/,\s*/)
    |> Enum.map(&String.to_integer/1)
  end

  def knot(length, {index, skip, string}) do
    string = string
    |> Enum.split(index)
    |> (fn {a, b} -> b ++ a end).()
    |> Enum.split(length)
    |> (fn {a, b} -> Enum.reverse(a) ++ b end).()
    |> Enum.split(length(string) - index)
    |> (fn {a, b} -> b ++ a end).()
    {rem(index + length + skip, length(string)), skip + 1, string}
  end
end

input = System.argv
|> List.first

# Part one
input
|> KnotHash.hash
|> Enum.take(2)
|> (fn [a, b] -> a * b end).()
|> IO.inspect
