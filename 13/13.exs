defmodule Firewall do
  def layers(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.into(%{})
  end

  def severity(layers, delay) do
    layers
    |> catches(delay)
    |> Enum.map(fn {depth, range} -> depth * range end)
    |> Enum.sum
  end

  def catches(layers, delay) do
    layers
    |> Enum.filter(fn {depth, range} -> rem(delay + depth, range * 2 - 2) == 0 end)
  end

  def period(layers) do
    layers
    |> Map.values
    |> Enum.uniq
    |> Enum.reduce(&Kernel.*/2)
  end
end

layers = System.argv
|> List.first
|> Firewall.layers

# Part one
layers
|> Firewall.severity(0)
|> IO.inspect

# Part one
1..(Firewall.period(layers))
|> Enum.find(fn
  depth ->
    Firewall.catches(layers, depth) == []
end)
|> IO.inspect
