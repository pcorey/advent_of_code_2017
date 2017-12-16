defmodule PermutationPromenade do
  def period(input) do
    Enum.reduce_while(0..1_000_000_000, {"abcdefghijklmnop", %{}}, fn
      (i, {initial, map}) ->
        if Map.get(map, initial) do
          {:halt, i}
        else
          map = Map.put_new(map, initial, i)
          {:cont, {PermutationPromenade.dance(input, initial), map}}
        end
    end)
  end

  def dance(moves, initial) when is_binary(initial) do
    moves
    |> dance(String.split(initial, "", trim: true))
    |> Enum.join("")
  end

  def dance([], programs), do: programs

  def dance([["s", x] | moves], programs) do
    programs = programs
    |> Enum.split(-String.to_integer(x))
    |> (fn {a, b} -> b ++ a end).()
    dance(moves, programs)
  end

  def dance([["x", a, b] | moves], programs) do
    a = String.to_integer(a)
    b = String.to_integer(b)
    programs = programs
    |> List.replace_at(a, Enum.at(programs, b))
    |> List.replace_at(b, Enum.at(programs, a))
    dance(moves, programs)
  end

  def dance([["p", a, b] | moves], programs) do
    a = Enum.find_index(programs, &(&1 == a))
    b = Enum.find_index(programs, &(&1 == b))
    programs = programs
    |> List.replace_at(a, Enum.at(programs, b))
    |> List.replace_at(b, Enum.at(programs, a))
    dance(moves, programs)
  end
end

input = System.argv
|> hd()
|> String.split(",")
|> Enum.map(fn
  move ->
    ~r/(s)(\d+)|(x)(\d+)\/(\d+)|(p)(\w+)\/(\w+)/
    |> Regex.run(move)
    |> Enum.reject(&(&1 == ""))
    |> Enum.drop(1)
end)

# Part one
initial = input
|> PermutationPromenade.dance("abcdefghijklmnop")
|> IO.inspect

# Part two
period = PermutationPromenade.period(input)
Enum.reduce((div(1_000_000_000, period) * period + 1)..1_000_000_000, "abcdefghijklmnop", fn
  (i, initial) ->
    PermutationPromenade.dance(input, initial)
end)
|> IO.inspect
