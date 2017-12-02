# http://adventofcode.com/2017/day/1

System.argv
|> List.first
|> String.split("", trim: true)
|> (fn [hd | tl] -> [hd | tl] ++ [hd] end).()
|> Enum.map(&String.to_integer/1)
|> Enum.chunk_every(2, 1, :discard)
|> Enum.filter(fn [a | [b | []]] -> a == b end)
|> Enum.reduce(0, fn ([n | _], sum) -> sum + n end)
|> IO.inspect
