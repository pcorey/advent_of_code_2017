defmodule GarbageStream do
  def score(input) do
    input
    |> String.graphemes
    |> score(:score, 0, [])
    |> Enum.sum
  end

  defp score([], _, _, scores) do
    scores
  end

  defp score(["{" | stream], :score, score, scores) do
    score(stream, :score, score + 1, scores)
  end

  defp score(["}" | stream], :score, score, scores) do
    score(stream, :score, score - 1, [score | scores])
  end

  defp score(["," | stream], :score, score, scores) do
    score(stream, :score, score, scores)
  end

  defp score(["<" | stream], :score, score, scores) do
    score(stream, :garbage, score, scores)
  end

  defp score([">" | stream], :garbage, score, scores) do
    score(stream, :score, score, scores)
  end

  defp score(["!" | [_ | stream]], :garbage, score, scores) do
    score(stream, :garbage, score, scores)
  end

  defp score([_ | stream], :garbage, score, scores) do
    score(stream, :garbage, score, scores)
  end
end

input = System.argv
|> List.first

# Part one
input
|> GarbageStream.score
|> IO.inspect
