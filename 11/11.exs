defmodule Grid do
  def travel(steps) do
    steps
    |> Enum.reduce({{0, 0}, 0}, &(apply(__MODULE__, &1, [&2])))
  end

  def distance({x, y}) do
    step({x, y}, [])
    |> length
  end

  def n({{x,  y}, old_dist}), do: {{x,     y + 1},   max(old_dist, distance({x,     y + 1}))}
  def ne({{x, y}, old_dist}), do: {{x + 1, y + 0.5}, max(old_dist, distance({x + 1, y + 0.5}))}
  def se({{x, y}, old_dist}), do: {{x + 1, y - 0.5}, max(old_dist, distance({x + 1, y - 0.5}))}
  def s({{x,  y}, old_dist}), do: {{x,     y - 1},   max(old_dist, distance({x,     y - 1}))}
  def sw({{x, y}, old_dist}), do: {{x - 1, y - 0.5}, max(old_dist, distance({x - 1, y - 0.5}))}
  def nw({{x, y}, old_dist}), do: {{x - 1, y + 0.5}, max(old_dist, distance({x - 1, y + 0.5}))}

  defp step({x, y}, path) when x == 0  and y == 0,    do: path
  defp step({x, y}, path) when x >= 1  and y >= 0.5,  do: step({x - 1, y - 0.5}, [:ne | path])
  defp step({x, y}, path) when x <= -1 and y >= 0.5,  do: step({x + 1, y - 0.5}, [:nw | path])
  defp step({x, y}, path) when x >= 1  and y <= -0.5, do: step({x - 1, y + 0.5}, [:se | path])
  defp step({x, y}, path) when x <= -1 and y <= -0.5, do: step({x + 1, y + 0.5}, [:sw | path])
  defp step({x, y}, path) when y <= -1,               do: step({x,     y + 1},   [:s  | path])
  defp step({x, y}, path) when y >= 1,                do: step({x,     y - 1},   [:n  | path])
  defp step({x, y}, path) when x <= -1,               do: step({x + 1, y - 0.5}, [:ne | path])
  defp step({x, y}, path) when x >= 1,                do: step({x - 1, y - 0.5}, [:nw | path])
end

travel = System.argv
|> List.first
|> String.split(",")
|> Enum.map(&String.to_atom/1)
|> Grid.travel

# Part one
travel
|> elem(0)
|> Grid.distance
|> IO.inspect

# Part two
travel
|> elem(1)
|> IO.inspect
