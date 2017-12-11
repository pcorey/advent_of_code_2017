require Bitwise

defmodule KnotHash do
  def hash(input, index \\ 0, skip \\ 0, string \\ Enum.to_list(0..255)) do
    input
    |> Enum.reduce({index, skip, string}, &knot/2)
  end

  def knot(length, {index, skip, string}) do
    string = string
    |> Enum.split(index)
    |> (fn {a, b} -> b ++ a end).()
    |> Enum.split(length)
    |> (fn {a, b} -> Enum.reverse(a) ++ b end).()
    |> Enum.split(length(string) - index)
    |> (fn {a, b} -> b ++ a end).()
    {rem(index + length + skip, length(string)), skip + 1, string}
  end
end

input = System.argv
|> List.first

# Part one
input
|> String.split(~r/,\s*/)
|> Enum.map(&String.to_integer/1)
|> KnotHash.hash
|> elem(2)
|> Enum.take(2)
|> (fn [a, b] -> a * b end).()
|> IO.inspect

# Part two
key = input
|> String.to_charlist
|> Enum.concat([17, 31, 73, 47, 23])
sparse_hash = Enum.reduce(1..64, {0, 0, 0..255 |> Enum.to_list}, fn
  (n, {index, skip, out}) ->
    KnotHash.hash(key, index, skip, out)
end)
|> elem(2)

sparse_hash
|> Enum.chunk_every(16)
|> Enum.map(fn
  chunk ->
    Enum.reduce(chunk, &Bitwise.bxor/2)
end)
|> :erlang.list_to_binary
|> Base.encode16(case: :lower)
|> IO.inspect
