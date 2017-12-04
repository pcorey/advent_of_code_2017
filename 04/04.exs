defmodule Passphrase do
  def is_valid?(passphrase) do
    words = String.split(passphrase, " ")
    unique_words = Enum.uniq(words)
    words == unique_words
  end
end

input = System.argv |> hd()

# Part one
input
|> String.split("\n", trim: true)
|> Enum.filter(&Passphrase.is_valid?/1)
|> length
|> IO.inspect
