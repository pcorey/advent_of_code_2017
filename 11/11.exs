defmodule Grid do
  def travel(steps) do
    steps
    |> Enum.reduce({0, 0}, &(apply(__MODULE__, &1, [&2])))
  end

  def shortest_path({x, y}) do
    step({x, y}, [])
  end

  def n({x, y}), do: {x, y + 1}
  def ne({x, y}), do: {x + 1, y + 0.5}
  def se({x, y}), do: {x + 1, y - 0.5}
  def s({x, y}), do: {x, y - 1}
  def sw({x, y}), do: {x - 1, y - 0.5}
  def nw({x, y}), do: {x - 1, y + 0.5}

  defp step({x, y}, path) when x == 0 and y == 0, do: path
  defp step({x, y}, path) when x >= 1 and y >= 0.5, do: step({x - 1, y - 0.5}, [:ne | path])
  defp step({x, y}, path) when x <= -1 and y >= 0.5, do: step({x + 1, y - 0.5}, [:nw | path])
  defp step({x, y}, path) when x >= 1 and y <= -0.5, do: step({x - 1, y + 0.5}, [:se | path])
  defp step({x, y}, path) when x <= -1 and y <= -0.5, do: step({x + 1, y + 0.5}, [:sw | path])
  defp step({x, y}, path) when y <= -1, do: step({x, y + 1}, [:s | path])
  defp step({x, y}, path) when y >= 1, do: step({x, y - 1}, [:n | path])
  defp step({x, y}, path) when x <= -1, do: step({x + 1, y - 0.5}, [:ne | path])
  defp step({x, y}, path) when x >= 1, do: step({x - 1, y - 0.5}, [:nw | path])
end

System.argv
|> List.first
|> String.split(",")
|> Enum.map(&String.to_atom/1)
|> Grid.travel
|> Grid.shortest_path
|> length
|> IO.inspect
