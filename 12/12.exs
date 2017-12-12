defmodule Pipes do
  def group_size(input, process) do
    input
    |> reduce
    |> group(process)
    |> MapSet.to_list
    |> length
  end

  defp reduce(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> List.flatten
    |> Enum.into(%{})
  end

  defp parse_line(line) do
    [from | to] = line
    |> String.replace(~r/<->|,/, "")
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    {from, to}
  end

  defp group(map, process) do
    group(map, %MapSet{}, process)
  end

  defp group(map, set, process) do
    if MapSet.member?(set, process) do
      set
    else
      map[process]
      |> Enum.map(&group(map, MapSet.put(set, process), &1))
      |> Enum.reduce(&(MapSet.union(&1, &2)))
    end
  end
end

input = List.first(System.argv)

# Part one
input
|> Pipes.group_size(0)
|> IO.inspect
