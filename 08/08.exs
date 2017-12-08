defmodule Registers do
  def compute(input) do
    input
    |> parse
    |> process
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn
      [r1, op1, v1, _, r2, op2, v2] ->
        {
          r1,
          String.to_atom(op1),
          String.to_integer(v1),
          r2,
          String.to_atom(op2),
          String.to_integer(v2)
        }
    end)
  end

  defp process(instructions) do
    instructions
    |> Enum.reduce(%{}, fn
      ({r1, op1, v1, r2, op2, v2}, registers) ->
        if apply(Kernel, op2, [Map.get(registers, r2, 0), v2]) do
          val = Map.get(registers, r1) || 0
          Map.put(registers, r1, apply(__MODULE__, op1, [val, v1]))
        else
          registers
        end
    end)
  end

  def inc(a, b), do: a + b
  def dec(a, b), do: a - b
end


input = System.argv
|> List.first

# Part one
input
|> Registers.compute
|> Map.values
|> Enum.max
|> IO.inspect
