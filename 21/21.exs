require ExUnit.Assertions

defmodule FractalArt do
  def stream(input) do
    replacements = input
    |> parse
    Stream.iterate(%{{0, 0} => ".", {1, 0} => "#", {2, 0} => ".",
                     {0, 1} => ".", {1, 1} => ".", {2, 1} => "#",
                     {0, 2} => "#", {1, 2} => "#", {2, 2} => "#"}, fn
      map ->
        width = :math.sqrt(length(map |> Map.keys)) |> trunc
        size = if rem(width, 2) == 0, do: 2, else: 3
        map
        |> chunk(size)
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
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn
      ({row, y}, map) ->
        row
        |> Enum.reduce(map, fn
          ({v, x}, map) ->
            Map.put(map, {x, y}, v)
        end)
    end)
  end

  defp rotate(%{{0, 0} => a, {1, 0} => b, {2, 0} => c,
                {0, 1} => d, {1, 1} => e, {2, 1} => f,
                {0, 2} => g, {1, 2} => h, {2, 2} => i}) do
    %{{0, 0} => c, {1, 0} => f, {2, 0} => i,
      {0, 1} => b, {1, 1} => e, {2, 1} => h,
      {0, 2} => a, {1, 2} => d, {2, 2} => g}
  end

  defp rotate(%{{0, 0} => a, {1, 0} => b,
                {0, 1} => c, {1, 1} => d}) do
    %{{0, 0} => b, {1, 0} => d,
      {0, 1} => a, {1, 1} => c}
  end

  defp flip(%{{0, 0} => a, {1, 0} => b, {2, 0} => c,
              {0, 1} => d, {1, 1} => e, {2, 1} => f,
              {0, 2} => g, {1, 2} => h, {2, 2} => i}) do
    %{{0, 0} => c, {1, 0} => b, {2, 0} => a,
      {0, 1} => f, {1, 1} => e, {2, 1} => d,
      {0, 2} => i, {1, 2} => h, {2, 2} => g}
  end

  defp flip(%{{0, 0} => a, {1, 0} => b,
              {0, 1} => c, {1, 1} => d}) do
    %{{0, 0} => b, {1, 0} => a,
      {0, 1} => d, {1, 1} => c}
  end

  defp replace(parts, replacements) do
    parts
    |> Enum.reduce(%{}, fn
      ({k, v}, map) ->
        Map.put(map, k, Map.get(replacements, v))
    end)
  end

  def chunk(map, size) do
    length = length(map |> Map.values)
    width = :math.sqrt(length) |> trunc
    chunks = div(width, size)
    # parts = Stream.cycle([%{}]) |> Enum.take(chunks * chunks)
    map
    |> Map.keys
    |> Enum.sort_by(fn {x, y} -> {y, x} end)
    |> Enum.reduce(%{}, fn
      ({x, y}, parts) ->
        x2 = div(x, size)
        y2 = div(y, size)
        part = Map.get(parts, {x2, y2}) || %{}
        part = Map.put(part, {rem(x, size), rem(y, size)}, Map.get(map, {x, y}))
        Map.put(parts, {x2, y2}, part)
    end)
  end

  defp put(l, i, v) do
    if i >= length(l) do
      List.insert_at(l, i, v)
    else
      List.replace_at(l, i, v)
    end
  end

  defp chunk_size(parts) do
    key = parts
    |> Map.keys
    |> List.first
    chunk = parts
    |> Map.get(key)
    length = chunk
    |> Map.values
    |> length
    :math.sqrt(length) |> trunc
  end

  def flatten(parts) do
    size = chunk_size(parts)
    parts
    |> Enum.reduce(%{}, fn
      ({{x1, y1}, chunk}, map) ->
        chunk
        |> Enum.reduce(map, fn
          ({{x2, y2}, v}, map) ->
            Map.put(map, {x1 * size + x2, y1 * size + y2}, v)
        end)
    end)
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
