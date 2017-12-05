defmodule Maze do
  def stream(jumps, offset) do
    Stream.unfold({0, build_map(jumps), offset}, &next/1)
  end

  defp build_map(jumps) do
    jumps
    |> Enum.with_index
    |> Enum.map(fn {v, i} -> {i, v} end)
    |> Enum.into(%{})
  end

  def next({index, jumps, offset}) do
    case jumps[index] do
      nil ->
        nil
      jump ->
        next = Map.put(jumps, index, jump + offset.(jump))
        {jump, {index + jump, next, offset}}
    end
  end

end

input = System.argv
|> List.first
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)

# Part one
input
|> Maze.stream(fn _ -> 1 end)
|> Enum.to_list
|> length
|> IO.inspect

# Part two
input
|> Maze.stream(fn n -> if n >= 3, do: -1, else: 1 end)
|> Enum.to_list
|> length
|> IO.inspect
