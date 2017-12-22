defmodule SporificaVirus do
  def stream(input) do
    m = parse(input)
    Stream.iterate({m, {0, 0}, {0, -1}, 0}, fn
      {m, p, d, c} ->
        case Map.get(m, p) do
          :weakened ->
            {Map.put(m, p, :infected), move(p, d), d, c + 1}
          :infected ->
            {Map.put(m, p, :flagged), move(p, right(d)), right(d), c}
          :flagged ->
            {Map.delete(m, p), move(p, reverse(d)), reverse(d), c}
          nil ->
            {Map.put(m, p, :weakened), move(p, left(d)), left(d), c}
        end
    end)
  end

  def parse(input) do
    half = input
    |> String.split("\n")
    |> length
    |> Kernel./(2)
    |> Float.floor
    |> trunc
    split = input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    coords = for y <- -half..half, x <- -half..half do 
      {x, y, split |> Enum.at(y + half) |> Enum.at(x + half)}
    end
    coords
    |> Enum.filter(fn {x, y, v} -> v == "#" end)
    |> Enum.reduce(%{}, fn
      ({x, y, v}, m) ->
        Map.put(m, {x, y}, :infected)
    end)
  end

  defp right({0, -1}), do: {1, 0}
  defp right({1, 0}),  do: {0, 1}
  defp right({0, 1}),  do: {-1, 0}
  defp right({-1, 0}), do: {0, -1}

  defp left({0, -1}), do: {-1, 0}
  defp left({-1, 0}), do: {0, 1}
  defp left({0, 1}),  do: {1, 0}
  defp left({1, 0}),  do: {0, -1}

  defp reverse({0, -1}), do: {0, 1}
  defp reverse({-1, 0}), do: {1, 0}
  defp reverse({0, 1}),  do: {0, -1}
  defp reverse({1, 0}),  do: {-1, 0}

  defp move({a, b}, {c, d}), do: {a + c, b + d}
end

System.argv
|> List.first
|> SporificaVirus.stream
|> Enum.at(10000000)
|> IO.inspect
