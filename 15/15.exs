defmodule Generators do
  def judge(seeds, rounds) do
    pairs(seeds)
    |> Enum.take(rounds)
    |> Enum.filter(fn
      {a, b} ->
        padding = <<0x00, 0x00>>
        <<a :: 16, _ :: binary>> = :binary.encode_unsigned(a, :little) <> padding
        <<b :: 16, _ :: binary>> = :binary.encode_unsigned(b, :little) <> padding
        a == b
    end)
    |> length
  end

  def pairs(seeds) do
    Stream.iterate(next_pair(seeds), fn
      values ->
        next_pair(values)
    end)
  end

  defp next_pair({a, b}), do: {next(a, 16807), next(b, 48271)}

  defp next(value, factor), do: rem(value * factor, 2147483647)
end

seeds = System.argv
|> List.first()
|> String.split("\n")
|> Enum.map(&String.split/1)
|> List.flatten()
|> (&({Enum.at(&1, 4), Enum.at(&1, 9)})).()
|> (fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end).()

Generators.judge(seeds, 40_000_000)
|> IO.inspect
