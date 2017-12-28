require ExUnit.Assertions

defmodule FractalArt do
  def stream(input) do
    replacements = input
    |> parse
    |> IO.inspect
    Stream.iterate(%{{0, 0} => ".", {1, 0} => "#", {2, 0} => ".",
                     {0, 1} => ".", {1, 1} => ".", {2, 1} => "#",
                     {0, 2} => "#", {1, 2} => "#", {2, 2} => "#"}, fn
      map ->
        width = :math.sqrt(length(map |> Map.keys)) |> trunc
        size = if rem(width, 2) == 0, do: 2, else: 3
        map
        |> chunk(size)
        |> IO.inspect
        |> replace(replacements)
        |> flatten
    end)
  end

  def count_on(pixels) do
    pixels
    |> Map.values
    |> Enum.reject(&(&1 == "."))
    |> length
  end

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " => "))
    |> Enum.reduce(%{}, &build_map_entry/2)
  end

  defp build_map_entry([from, to], map) do
    from = parse_pattern(from)
    to = parse_pattern(to)
    map
    |> Map.put(from, to)
    |> Map.put(from |> rotate, to)
    |> Map.put(from |> rotate |> rotate, to)
    |> Map.put(from |> rotate |> rotate |> rotate, to)
    |> Map.put(from |> flip, to)
    |> Map.put(from |> flip |> rotate, to)
    |> Map.put(from |> flip |> rotate |> rotate, to)
    |> Map.put(from |> flip |> rotate |> rotate |> rotate, to)
  end

  defp parse_pattern(pattern) do
    pattern
    |> String.split("/")
    |> Enum.map(&String.graphemes/1)
    |> List.flatten
  end

  defp rotate([a, b,
               c, d]), do: [b, d,
                            a, c]

  defp rotate([a, b, c,
               d, e, f,
               g, h, i]), do: [c, f, i,
                               b, e, h,
                               a, d, g]

  defp flip([a, b,
             c, d]), do: [b, a,
                          d, c]

  defp flip([a, b, c,
             d, e, f,
             g, h, i]), do: [c, b, a,
                             f, e, d,
                             i, h, g]

  defp replace(parts, replacements) do
    Enum.map(parts, fn part -> Map.get(replacements, part) end)
  end

  def chunk(map, size) do
    IO.inspect(map)
    length = length(map |> Map.values)
    width = :math.sqrt(length) |> trunc
    chunks = div(width, size)
    parts = Stream.cycle([[]]) |> Enum.take(chunks * chunks)
    |> IO.inspect
    map
    |> Map.keys
    |> Enum.sort_by(fn {x, y} -> {y, x} end)
    |> Enum.reduce(parts, fn
      ({x, y}, parts) ->
        i = rem(y, chunks) * chunks + rem(x, chunks)
        List.replace_at(parts, i, Enum.at(parts, i) ++ [Map.get(map, {x, y})])
    end)
  end

  defp put(l, i, v) do
    if i >= length(l) do
      List.insert_at(l, i, v)
    else
      List.replace_at(l, i, v)
    end
  end

  def flatten(parts) do
    IO.inspect(parts)
    flat = List.flatten(parts)
    length = length(flat)
    width = :math.sqrt(length) |> trunc
    size = parts |> List.first |> List.first |> List.first |> length
    chunks = length(parts)
    dlc = div(length, chunks)
    dlw = div(length, width)
    for i <- 0..(length - 1) do
      i1 = div(i, dlc)
      i2 = rem(div(i, size), chunks)
      i3 = rem(div(i, dlw), size)
      i4 = rem(i, size)
      parts |> Enum.at(i1) |> Enum.at(i2) |> Enum.at(i3) |> Enum.at(i4)
    end
  end
end

stream = System.argv
|> List.first
|> FractalArt.stream

# Part one
after_five = stream
|> Enum.at(5)
|> FractalArt.count_on
|> IO.inspect

# Part two
after_eighteen = stream
|> Enum.at(18)
|> FractalArt.count_on
|> IO.inspect
