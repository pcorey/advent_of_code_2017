defmodule Duet do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
  end

  def execute(instructions) do
    execute(instructions,
            {0, %{"p" => 0, rcv: [], snd: []}},
            {0, %{"p" => 1, rcv: [], snd: []}})
  end

  def execute(_, {_, %{halt: true}}, {_, %{halt: true}, snd: snd}) do
    length(snd)
  end

  def execute(_, {_, %{wait: true, rcv: []}}, {_, %{wait: true, rcv: [], snd: snd}}) do
    length(snd)
  end

  def execute(instructions, {i0, mem0}, {i1, mem1}) do
    {i0, mem0, mem1} = execute_one(instructions, i0, mem0, mem1)
    {i1, mem1, mem0} = execute_one(instructions, i1, mem1, mem0)
    execute(instructions, {i0, mem0}, {i1, mem1})
  end

  def execute_one(_, i, mem0 = %{halt: true}, mem1) do
    {i, mem0, mem1}
  end

  def execute_one(instructions, i, mem0, mem1) when i < 0 or i >= length(instructions) do
    {i, Map.put(mem0, :halt, true), mem1}
  end

  def execute_one(instructions, i, mem0, mem1) do
    [instruction | args] = Enum.at(instructions, i)
    instruction = String.to_atom(instruction)
    apply(__MODULE__, instruction, [mem0, mem1, i | args])
  end

  # Part one:
  # def first_rcv(instructions) do
  #   first_rcv(instructions, 0, %{})
  # end

  # def first_rcv(_, _, %{rcv: rcv}), do: rcv
  # def first_rcv(instructions, i, mem) do
  #   [instruction | args] = Enum.at(instructions, i)
  #   instruction = String.to_atom(instruction)
  #   {i, mem} = apply(__MODULE__, instruction, [mem , i | args])
  #   first_rcv(instructions, i, mem)
  # end

  def snd(mem0, mem1, i, a) do
    v = get_value(mem0, a)
    {i + 1, Map.update!(mem0, :snd, &(&1 ++ [v])), Map.update!(mem1, :rcv, &(&1 ++ [v]))}
  end

  def set(mem0, mem1, i, a, b) do
    {i + 1, Map.put(mem0, a, get_value(mem0, b)), mem1}
  end

  def add(mem0, mem1, i, a, b) do
    {i + 1, Map.put(mem0, a, get_value(mem0, a) + get_value(mem0, b)), mem1}
  end

  def mul(mem0, mem1, i, a, b) do
    {i + 1, Map.put(mem0, a, get_value(mem0, a) * get_value(mem0, b)), mem1}
  end

  def mod(mem0, mem1, i, a, b) do
    {i + 1, Map.put(mem0, a, rem(get_value(mem0, a), get_value(mem0, b))), mem1}
  end

  def rcv(mem0, mem1, i, a) do
    case Map.get(mem0, :rcv) do
      [] ->
        {i, Map.put(mem0, :wait, true), mem1}
      [b | rest] ->
        {
          i + 1,
          mem0
          |> Map.put(a, b)
          |> Map.put(:wait, false)
          |> Map.put(:rcv, rest),
          mem1
        }
    end
  end

  def jgz(mem0, mem1, i, a, b) do
    case Map.get(mem0, a) > 0 do
      true ->
        {i + get_value(mem0, b), mem0, mem1}
      false ->
        {i + 1, mem0, mem1}
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
|> Duet.execute
|> IO.inspect
