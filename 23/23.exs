defmodule Coprocessor do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
  end

  def execute(instructions) do
    execute(instructions, {0, %{"a" => 0, mul: 0}})
  end

  def non_primes_between(b, c, i) do
    0..(div(c - b, 17))
    |> Enum.reject(&is_prime?(b + (&1 * i)))
    |> length
  end

  def is_prime?(n) do
    2..Enum.max([div(n - 1, 2), 2])
    |> Enum.all?(fn d -> rem(n, d) != 0 end)
  end

  def execute(instructions, {i, mem}) when i < 0 or i >= length(instructions), do: mem
  def execute(instructions, {i, mem}) do
    [instruction | args] = Enum.at(instructions, i)
    instruction = String.to_atom(instruction)
    execute(instructions, apply(__MODULE__, instruction, [mem, i | args]))
  end

  def set(mem, i, a, b) do
    {i + 1, Map.put(mem, a, get_value(mem, b))}
  end

  def sub(mem, i, a, b) do
    {i + 1, Map.put(mem, a, get_value(mem, a) - get_value(mem, b))}
  end

  def mul(mem = %{mul: mul}, i, a, b) do
    {i + 1, mem
            |> Map.put(a, get_value(mem, a) * get_value(mem, b))
            |> Map.put(:mul, mul + 1)}
  end

  def jnz(mem, i, a, b) do
    case get_value(mem, a) != 0 do
      true ->
        {i + get_value(mem, b), mem}
      false ->
        {i + 1, mem}
    end
  end

  defp get_value(mem, a) do
    case Regex.match?(~r/\d+/, a) do
      true  -> String.to_integer(a)
      false -> Map.get(mem, a, 0)
    end
  end
end

instructions = System.argv
|> List.first
|> Coprocessor.parse

# Part one
instructions
|> Coprocessor.execute
|> Map.get(:mul)
|> IO.inspect

# Part two
Coprocessor.non_primes_between(108100, 125100, 17)
|> IO.inspect
