defmodule GarbageStream do
  def score(input) do
    input
    |> String.graphemes
    |> process(:score, 0, {[], []})
    |> elem(0)
    |> Enum.sum
  end

  def garbage(input) do
    input
    |> String.graphemes
    |> process(:score, 0, {[], []})
    |> elem(1)
    |> length
  end

  defp process([], _, _, accum) do
    accum
  end

  defp process(["{" | stream], :score, score, accum) do
    process(stream, :score, score + 1, accum)
  end

  defp process(["}" | stream], :score, score, {scores, garbage}) do
    process(stream, :score, score - 1, {[score | scores], garbage})
  end

  defp process(["," | stream], :score, score, accum) do
    process(stream, :score, score, accum)
  end

  defp process(["<" | stream], :score, score, accum) do
    process(stream, :garbage, score, accum)
  end

  defp process([">" | stream], :garbage, score, accum) do
    process(stream, :score, score, accum)
  end

  defp process(["!" | [_ | stream]], :garbage, score, accum) do
    process(stream, :garbage, score, accum)
  end

  defp process([c | stream], :garbage, score, {scores, garbage}) do
    process(stream, :garbage, score, {scores, [c | garbage]})
  end
end

input = System.argv
|> List.first

# Part one
input
|> GarbageStream.score
|> IO.inspect

# Part two
input
|> GarbageStream.garbage
|> IO.inspect
