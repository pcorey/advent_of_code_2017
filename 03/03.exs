defmodule Spiral do
  import Integer, only: [is_even: 1]

  def steps_required(input) do
    stream()
    |> Enum.at(input - 1)
    |> distance
  end

  def stress_test(input) do
    Enum.reduce_while(stream(), %{{0, 0} => 1}, fn
      ({_, pos}, map) ->
        sum = Enum.sum(neighbors(map, pos))
        if sum > input do
          {:halt, sum}
        else
          {:cont, Map.put_new(map, pos, sum)}
        end
    end)
  end

  defp neighbors(map, {x, y}) do
    [
      Map.get(map, {x + 1, y}),
      Map.get(map, {x + 1, y + 1}),
      Map.get(map, {x,     y + 1}),
      Map.get(map, {x - 1, y + 1}),
      Map.get(map, {x - 1, y}),
      Map.get(map, {x - 1, y - 1}),
      Map.get(map, {x,     y - 1}),
      Map.get(map, {x + 1, y - 1})
    ]
    |> Enum.filter(&(&1))
  end

  defp stream do
    Stream.resource(&start/0, &next/1, fn _ -> :ok end)
  end

  defp distance({_, {x, y}}) do
    abs(x) + abs(y)
  end

  defp start, do: {1, {0, 0}, {1, 0}, 1, 1, 1}

  defp next({val, pos, dir, seg, len, 1}) do
    len = length(len, seg)
    next = {val + 1, move(pos, dir), turn(dir), seg + 1, len, len}
    {[{val, pos}], next}
  end

  defp next({val, pos, dir, seg, len, left}) do
    next = {val + 1, move(pos, dir), dir, seg, len, left - 1}
    {[{val, pos}], next}
  end

  defp move({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp turn({0,  1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, -1}
  defp turn({0, -1}), do: {1,  0}
  defp turn({1,  0}), do: {0,  1}

  defp length(len, seg) when is_even(seg), do: len + 1
  defp length(len, _), do: len
end

input = System.argv
|> List.first
|> String.to_integer

# Part one
Spiral.steps_required(input)
|> IO.inspect

# Part two
Spiral.stress_test(input)
|> IO.inspect
