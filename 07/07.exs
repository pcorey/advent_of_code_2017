defmodule Towers do
  def reconstruct(input) do
    input
    |> parse
    |> edges
    |> root
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [name | [weight | above]] = line
    |> String.replace(~r/\(|\)|,|\-> /, "")
    |> String.split
    {name, weight |> String.to_integer, above}
  end

  defp edges(parsed) do
    for {name, _weight, above} <- parsed, next <- above do
      {name, next}
    end
  end

  defp root(edges), do: root(edges, edges, List.first(edges))

  defp root([{c, a} | edges], all, {a, _}), do: root(all, all, {c, a})
  defp root([_ | edges], all, edge), do: root(edges, all, edge)
  defp root([], _, {a, _}), do: a

  # # I feel like this is cheating...
  # defp digraph(edges) do
  #   g = :digraph.new()
  #   Enum.each(edges, fn {a, _, _} -> :digraph.add_vertex(g, a) end)
  #   Enum.each(edges, fn {a, _, b} -> for c <- b, do: :digraph.add_edge(g, a, c) end)
  #   :digraph_utils.arborescence_root(g)
  # end
end

input = System.argv
|> List.first

input
|> Towers.reconstruct
|> IO.inspect
