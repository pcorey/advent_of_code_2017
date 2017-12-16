defmodule Generators do
  use Bitwise

  def judge(seeds, rounds, divisors \\ nil) do
    pairs(seeds, divisors)
    |> Enum.take(rounds)
    |> Enum.filter(fn
      {a, b} ->
        (a &&& 0xFFFF) == (b &&& 0xFFFF)
    end)
    |> length
  end

  def pairs(seeds, divisors) do
    Stream.iterate(next_pair(seeds, divisors), fn
      values ->
        next_pair(values, divisors)
    end)
  end

  defp next_pair({a, b}, nil), do: {next(a, 16807), next(b, 48271)}
  defp next_pair({a, b}, {c, d}), do: {next(a, 16807, c), next(b, 48271, d)}

  defp next(value, factor), do: rem(value * factor, 2147483647)
  defp next(value, factor, divisor) do
    result = rem(value * factor, 2147483647)
    if rem(result, divisor) == 0 do
      result
    else
      next(result, factor, divisor)
    end
  end
end

seeds = System.argv
|> List.first()
|> String.split("\n")
|> Enum.map(&String.split/1)
|> List.flatten()
|> (&({Enum.at(&1, 4), Enum.at(&1, 9)})).()
|> (fn {a, b} -> {String.to_integer(a), String.to_integer(b)} end).()

# Part one
Generators.judge(seeds, 40_000_000)
|> IO.inspect

# Part two
Generators.judge(seeds, 5_000_000, {4, 8})
|> IO.inspect
