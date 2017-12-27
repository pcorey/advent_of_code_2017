defmodule Bridge do
  def build(input) when is_binary(input) do
    input
    |> parse
    |> build(0)
    |> Enum.map(fn
      bridge ->
        Enum.reduce(bridge, 0, fn({a, b}, s) -> s + a + b end)
    end)
    |> Enum.max
  end

  def build([], _), do: []
  def build(parts, pins) do
    find_fitting_part(parts, pins)
    |> Enum.map(fn
      {{a, b}, rest} ->
        [[]]
        |> Kernel.++(build(rest, b))
        |> Enum.map(&([{a, b}] ++ &1))
    end)
    |> List.foldl([], &(&2 ++ &1))
  end

  defp find_fitting_part(parts, pins) do
    parts
    |> Enum.filter(fn {a, b} -> a == pins || b == pins end)
    |> Enum.map(fn
      {^pins, b} ->
        {{pins, b}, List.delete(parts, {pins, b})}
      {a, ^pins} ->
        {{pins, a}, List.delete(parts, {a, pins})}
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "/"))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
    |> Enum.map(&List.to_tuple/1)
  end
end

System.argv
|> hd
|> Bridge.build
|> IO.inspect
