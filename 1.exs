# http://adventofcode.com/2017/day/1

sequence = System.argv
|> List.first
|> String.split("", trim: true)
|> Enum.map(&String.to_integer/1)

# Part One
sequence
|> (fn [hd | tl] -> [hd | tl] ++ [hd] end).()
|> Enum.chunk_every(2, 1, :discard)
|> Enum.filter(fn [a, b] -> a == b end)
|> Enum.reduce(0, fn ([n , _], sum) -> sum + n end)
|> IO.inspect

# Part Two
sequence
|> Enum.with_index
|> Enum.map(fn
  {part, index} ->
    sequence_length = length(sequence)
    offset = div(sequence_length, 2)
    {part, Enum.at(sequence, rem(index + offset, sequence_length))}
end)
|> Enum.filter(fn {a, b} -> a == b end)
|> Enum.reduce(0, fn ({n, _}, sum) -> sum + n end)
|> IO.inspect
