require Bitwise

defmodule KnotHash do
  def hash(input) do
    key = input
    |> String.to_charlist
    |> Enum.concat([17, 31, 73, 47, 23])
    sparse_hash = Enum.reduce(1..64, {0, 0, 0..255 |> Enum.to_list}, fn
      (_, {index, skip, out}) ->
        round(key, index, skip, out)
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
  end

  defp round(input, index, skip, string) do
    input
    |> Enum.reduce({index, skip, string}, &knot/2)
  end

  defp knot(length, {index, skip, string}) do
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

defmodule Disk do
  def hashes(key) do
    hashes = for i <- 0..127, do: KnotHash.hash("#{key}-#{i}")
    Enum.map(hashes, &reduce(&1 |> String.upcase |> Base.decode16!, ""))
  end

  def reduce(<<>>, s), do: s
  def reduce(<<1 :: size(1), rest :: bitstring>>, s), do:
    reduce(rest, s <> "#")
  def reduce(<<0 :: size(1), rest :: bitstring>>, s), do:
    reduce(rest, s <> ".")
end

key = System.argv
|> List.first
|> Disk.hashes
|> Enum.join()
|> String.split("")
|> Enum.filter(&(&1 == "#"))
|> length
|> IO.inspect
