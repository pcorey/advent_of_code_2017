defmodule MemoryBanks do
  def count_cycles(blocks) do
    blocks
    |> redistributions
    |> Enum.reduce_while(%{}, fn
      (redistribution, map) ->
        case map[redistribution] do
          nil ->
            {:cont, Map.put_new(map, redistribution, :ok)}
          _ ->
            {:halt, Map.keys(map)}
        end
    end)
    |> length
  end

  def redistributions(blocks) do
    Stream.iterate(blocks, &redistribute/1)
  end

  defp redistribute(blocks) do
    {max, max_index} = blocks
    |> Enum.with_index
    |> Enum.max_by(&elem(&1, 0))
    Stream.cycle([1])
    |> Enum.take(max)
    |> Enum.with_index
    |> Enum.reduce(blocks, fn
      ({n, index}, blocks) ->
        index = rem(index + max_index + 1, length(blocks))
        List.update_at(blocks, index, &(&1 + n))
    end)
    |> List.update_at(max_index, &(&1 - max))
  end
end

input = System.argv
|> Enum.map(&String.to_integer/1)

# Part one
input
|> MemoryBanks.count_cycles
|> IO.inspect

# Part two
input
|> MemoryBanks.redistributions
|> Enum.reduce_while(%{}, fn
  (redistribution, map) ->
    case map[redistribution] do
      nil ->
        {:cont, Map.put_new(map, redistribution, :ok)}
      _ ->
        {:halt, redistribution}
    end
end)
|> MemoryBanks.count_cycles
|> IO.inspect
