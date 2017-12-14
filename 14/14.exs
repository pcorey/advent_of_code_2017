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
  def squares(key) do
    hashes = for i <- 0..127, do: KnotHash.hash("#{key}-#{i}")
    hashes
    |> Enum.map(&String.upcase/1)
    |> Enum.map(&Base.decode16!/1)
    |> Enum.with_index
    |> Enum.reduce(%MapSet{}, fn ({h, y}, m) -> reduce(h, {0, y, m}) end)
  end

  def regions(squares), do: regions(MapSet.to_list(squares), squares)

  def regions([], _), do: 0
  def regions([square | _], squares) do
    squares = MapSet.difference(squares, crawl(squares, [square]))
    1 + regions(MapSet.to_list(squares), squares)
  end

  defp crawl(_, _, region \\ %MapSet{})
  defp crawl(_, [], region), do: region
  defp crawl(squares, [{x, y} | rest], region) do
    squares = MapSet.delete(squares, {x, y})
    region = MapSet.put(region, {x, y})
    next = [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.filter(&(MapSet.member?(squares, &1) && !MapSet.member?(region, &1)))
    crawl(squares, rest ++ next, region)
  end

  defp reduce(<<>>, {_, _, m}), do: m
  defp reduce(<<1 :: size(1), rest :: bitstring>>, {x, y, m}), do:
    reduce(rest, {x + 1, y, MapSet.put(m, {x, y})})
  defp reduce(<<0 :: size(1), rest :: bitstring>>, {x, y, m}), do:
    reduce(rest, {x + 1, y, m})
end

squares = System.argv
|> List.first
|> Disk.squares

# Part one
squares
|> MapSet.to_list()
|> length
|> IO.inspect

# Part one
squares
|> Disk.regions
|> IO.inspect
