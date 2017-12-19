defmodule Tubes do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def find_path(tubes) do
    starting_point = get_starting_point(tubes)
    trace_path(tubes, starting_point)
  end

  defp get_starting_point(tubes) do
    {tubes |> hd |> Enum.find_index(&(&1 == "|")), 0}
  end

  defp trace_path(tubes, {px, py}, {dx, dy} \\ {0, 1}, path \\ [], count \\ 0) do
    v = tubes |> at(px, py)
    cond do
      Regex.match?(~r/\w/, v) ->
        trace_path(tubes, {px + dx, py + dy}, {dx, dy}, [v | path], count + 1)
      Regex.match?(~r/[-|]/, v) ->
        trace_path(tubes, {px + dx, py + dy}, {dx, dy}, path, count + 1)
      Regex.match?(~r/\+/, v) ->
        {dx, dy} = turn(tubes, px, py, {-dx, -dy})
        trace_path(tubes, {px + dx, py + dy}, {dx, dy}, path, count + 1)
      true ->
        {path |> Enum.reverse, count}
    end
  end

  defp turn(tubes, x, y, dir) do
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    |> Enum.reject(&(&1 == dir))
    |> Enum.find(fn
      {dx, dy} ->
        Regex.match?(~r/\w|[-|]/, at(tubes, x + dx, y + dy))
    end)
  end

  defp at(tubes, x, y) do
    case tubes |> Enum.at(y) do
      nil ->
        " "
      row ->
        row |> Enum.at(x) || " "
    end
  end
end

tubes = System.argv
|> hd
|> Tubes.parse

# Part one
tubes
|> Tubes.find_path
|> elem(0)
|> Enum.join("")
|> IO.inspect

# Part two
tubes
|> Tubes.find_path
|> elem(1)
|> IO.inspect
