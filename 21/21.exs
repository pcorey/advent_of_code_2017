defmodule FractalArt do
  def stream(input) do
    replacements = input
    |> parse

    Stream.iterate([".", "#", ".", ".", ".", "#", "#", "#", "#"], fn
      flat ->
        width = :math.sqrt(length(flat)) |> trunc
        size = if rem(width, 2) == 0, do: 2, else: 3
        flat
        |> chunk(size)
        |> replace(replacements)
        |> flatten
    end)
  end

  def count_on(pixels) do
    pixels
    |> List.flatten
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
  end

  defp rotate([[a, b],
               [c, d]]), do: [[b, d],
                              [a, c]]

  defp rotate([[a, b, c],
               [d, e, f],
               [g, h, i]]), do: [[c, f, i],
                                 [b, e, h],
                                 [a, d, g]]

  defp flip([[a, b],
             [c, d]]), do: [[b, a],
                            [d, c]]

  defp flip([[a, b, c],
             [d, e, f],
             [g, h, i]]), do: [[c, b, a],
                               [f, e, d],
                               [i, h, g]]

  defp replace(parts, replacements) do
    Enum.map(parts, fn
      rows ->
        Enum.map(rows, fn
          row ->
            Map.get(replacements, row)
        end)
    end)
  end

  def chunk(pixels, size) do
    length = length(pixels)
    width = :math.sqrt(length) |> trunc
    chunks = div(width, size)
    parts = []
    0..(length - 1)
    |> Enum.reduce([], fn
      (i, parts) ->
        i1 = div(i, div(length, chunks))
        i2 = rem(div(i, size), chunks)
        i3 = rem(div(i, div(length, width)), size)
        i4 = rem(i, size)
        a = (parts |> Enum.at(i1)) || []
        b = (a |> Enum.at(i2)) || []
        c = (b |> Enum.at(i3)) || []
        put(parts, i1, put(a, i2, put(b, i3, put(c, i4, pixels |> Enum.at(i)))))
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
    flat = List.flatten(parts)
    length = length(flat)
    width = :math.sqrt(length) |> trunc
    size = parts |> List.first |> List.first |> List.first |> length
    chunks = length(parts)
    for i <- 0..(length - 1) do
      i1 = div(i, div(length, chunks))
      i2 = rem(div(i, size), chunks)
      i3 = rem(div(i, div(length, width)), size)
      i4 = rem(i, size)
      parts |> Enum.at(i1) |> Enum.at(i2) |> Enum.at(i3) |> Enum.at(i4)
    end
  end
end

stream = System.argv
|> List.first
|> FractalArt.stream

# Part one
stream
|> Enum.at(5)
|> FractalArt.count_on
|> IO.inspect

