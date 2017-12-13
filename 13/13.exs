defmodule Firewall do
  def layers(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.into(%{})
  end

  def severity(layers) do
    layers
    |> Enum.filter(fn {depth, range} -> rem(depth, range * 2 - 2) == 0 end)
    |> Enum.map(fn {depth, range} -> depth * range end)
    |> Enum.sum
  end
end

layers = System.argv
|> List.first
|> Firewall.layers

# Part one
layers
|> Firewall.severity
|> IO.inspect
