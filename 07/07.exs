defmodule Towers do
  def tree(input) do
    input
    |> parse
    |> map
  end

  def find_unbalanced_disc(tree) do
    tree
    |> Enum.find(fn
      {_, {_, []}} ->
        false
      {_, {_, subs}} ->
        subs
        |> Enum.map(&weigh(&1, tree))
        |> Enum.sort
        |> (&(Enum.dedup(&1) != [List.first(&1)])).()
    end)
  end

  def root(tree) do
    root(tree |> Map.keys |> List.first, tree)
  end

  defp root(name, tree) do
    case Enum.find(tree, fn {_, {_, subs}} -> name in subs end) do
      nil ->
        name
      {name, _} ->
        root(name, tree)
    end
  end

  defp subs(name, tree), do: tree[name] |> elem(1)

  defp parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [name | [weight | subs]] = line
    |> String.replace(~r/\(|\)|,|\-> /, "")
    |> String.split
    {name, {weight |> String.to_integer, subs}}
  end

  defp map(nodes), do: Enum.into(nodes, %{})

  def weigh(name, tree) do
    subs(name, tree)
    |> Enum.map(&weigh(&1, tree))
    |> Enum.sum
    |> (fn sum -> sum + elem(tree[name], 0) end).()
  end

  # # I feel like this is cheating...
  # defp digraph(edges) do
  #   g = :digraph.new()
  #   Enum.each(edges, fn {a, _, _} -> :digraph.add_vertex(g, a) end)
  #   Enum.each(edges, fn {a, _, b} -> for c <- b, do: :digraph.add_edge(g, a, c) end)
  #   :digraph_utils.arborescence_root(g)
  # end
end

tree = System.argv
|> List.first
|> Towers.tree

# Part one
tree
|> Towers.root
|> IO.inspect

# Part two
{_, {_, towers}} = tree
|> Towers.find_unbalanced_disc

towers
|> Enum.map(&{&1, Towers.weigh(&1, tree)})
|> IO.inspect
|> Enum.reduce_while([], fn
  (a, []) -> {:cont, [a]}
  (a, [b]) -> {:cont, [a, b]}
  ({_, b}, rest = [{_, b, _}, {_, b, _}]) -> {:cont, rest}
  ({_, b}, [{_, b}, {c, d}]) -> {:halt, {c, d, b}}
  ({_, b}, [{c, d}, {_, b}]) -> {:halt, {c, d, b}}
  ({a, b}, [{_, c}, {_, c}]) -> {:halt, {a, b, c}}
end)
|> (fn {name, wrong, right} -> elem(tree[name], 0) - (wrong - right) end).()
|> IO.inspect
