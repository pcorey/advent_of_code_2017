defmodule Spiral do
  import Integer, only: [is_even: 1]

  def stream do
    Stream.resource(&start/0, &next/1, fn _ -> :ok end)
  end

  def steps_required(square) do
    stream()
    |> Enum.at(square - 1)
    |> distance
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

square = System.argv
|> List.first
|> String.to_integer

# Part one
Spiral.steps_required(square)
|> IO.inspect
