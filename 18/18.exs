defmodule Duet do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
  end

  def first_rcv(instructions) do
    first_rcv(instructions, 0, %{})
  end

  def first_rcv(_, _, %{rcv: rcv}), do: rcv
  def first_rcv(instructions, i, mem) do
    [instruction | args] = Enum.at(instructions, i)
    instruction = String.to_atom(instruction)
    {i, mem} = apply(__MODULE__, instruction, [mem , i | args])
    first_rcv(instructions, i, mem)
  end

  def snd(mem, i, a) do
    {i + 1, Map.put(mem, :snd, get_value(mem, a))}
  end

  def set(mem, i, a, b) do
    {i + 1, Map.put(mem, a, get_value(mem, b))}
  end

  def add(mem, i, a, b) do
    {i + 1, Map.put(mem, a, get_value(mem, a) + get_value(mem, b))}
  end

  def mul(mem, i, a, b) do
    {i + 1, Map.put(mem, a, get_value(mem, a) * get_value(mem, b))}
  end

  def mod(mem, i, a, b) do
    {i + 1, Map.put(mem, a, rem(get_value(mem, a), get_value(mem, b)))}
  end

  def rcv(mem, i, a) do
    case Map.get(mem, :snd) do
      0 -> {i + 1, mem}
      b ->
        {
          i + 1,
          mem
          |> Map.put(a, b)
          |> Map.put_new_lazy(:rcv, fn -> b end)
        }
    end
  end

  def jgz(mem, i, a, b) do
    case Map.get(mem, a) > 0 do
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
|> Duet.parse

# Part one
instructions
|> Duet.first_rcv
|> IO.inspect
