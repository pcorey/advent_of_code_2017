defmodule PermutationPromenade do
  @initial "abcdefghijklmnop"

  def dance(moves) do
    moves
    |> dance(String.split(@initial, "", trim: true))
    |> Enum.join("")
  end

  defp dance([], programs), do: programs

  defp dance([["s", x] | moves], programs) do
    programs = programs
    |> Enum.split(-String.to_integer(x))
    |> (fn {a, b} -> b ++ a end).()
    dance(moves, programs)
  end

  defp dance([["x", a, b] | moves], programs) do
    a = String.to_integer(a)
    b = String.to_integer(b)
    programs = programs
    |> List.replace_at(a, Enum.at(programs, b))
    |> List.replace_at(b, Enum.at(programs, a))
    dance(moves, programs)
  end

  defp dance([["p", a, b] | moves], programs) do
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
input
|> PermutationPromenade.dance
|> IO.inspect
