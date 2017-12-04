defmodule Passphrase do
  def is_valid_1?(passphrase) do
    words = String.split(passphrase, " ")
    no_duplicates?(words)
  end

  def is_valid_2?(passphrase) do
    words = String.split(passphrase, " ")
    no_duplicates?(words) && no_anagrams?(words)
  end

  defp no_duplicates?(words) do
    unique_words = Enum.uniq(words)
    words == unique_words
  end

  defp no_anagrams?(words) do
    words
    |> Enum.reduce(%{}, fn
      (word, map) ->
        sorted = word
        |> String.split("", trim: true)
        |> Enum.sort
        Map.put_new(map, sorted, :ok)
    end)
    |> Map.keys
    |> length
    |> Kernel.==(length(words))
  end
end

input = System.argv |> hd()

# Part one
input
|> String.split("\n", trim: true)
|> Enum.filter(&Passphrase.is_valid_1?/1)
|> length
|> IO.inspect

# Part two
input
|> String.split("\n", trim: true)
|> Enum.filter(&Passphrase.is_valid_2?/1)
|> length
|> IO.inspect
