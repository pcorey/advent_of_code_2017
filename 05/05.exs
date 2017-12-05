defmodule Maze do
  def stream(jumps) do
    Stream.unfold({0, jumps}, &next/1)
  end

  def next({index, jumps}) when index >= length(jumps), do: nil

  def next({index, jumps}) do
    jump = Enum.at(jumps, index)
    {jump, {index + jump, List.replace_at(jumps, index, jump + 1)}}
  end
end

input = System.argv
|> List.first
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)

input
|> Maze.stream
|> Enum.to_list
|> length
|> IO.inspect
