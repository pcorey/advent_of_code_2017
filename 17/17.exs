defmodule Spinlock do
  def spin(steps, iterations) do
    steps
    |> stream
    |> Enum.at(iterations - 1)
    |> next_value
  end

  def zeros(steps) do
    Stream.unfold({0, 0, steps, 1}, fn
      {position, v1, steps, v2} ->
        if rem(position + steps, v2) == 0 do
          {v2, {rem(position + steps, v2) + 1, v2, steps, v2 + 1}}
        else
          {v1, {rem(position + steps, v2) + 1, v1, steps, v2 + 1}}
        end
    end)
  end

  defp next_value({position, list}) do
    Enum.at(list, rem(position + 1, length(list)))
  end

  defp stream(steps) do
    Stream.unfold({[0], 0, 1, steps}, fn
      {list, position, value, steps} ->
        position = rem(position + steps, length(list)) + 1
        list = List.insert_at(list, position, value)
        {{position, list}, {list, position, value + 1, steps}}
    end)
  end
end

input = System.argv
|> hd
|> String.to_integer

# Part one
input
|> Spinlock.spin(2017)
|> IO.inspect

# Part two
input
|> Spinlock.zeros
|> Enum.at(50_000_000)
|> IO.inspect
