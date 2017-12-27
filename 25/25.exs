defmodule TuringMachine do
  def parse(input) do
    [_, initial, steps] = Regex.run(~r/state (\w+)\.\n.*after (\d+) steps/m, input)
    states = input
    |> String.split(~r/^$/m)
    |> Enum.drop(1)
    |> Enum.reduce(%{}, fn
      (input, states) ->
        [_, state, w0, m0, c0, w1, m1, c1] = ~r/
          .*In\ state\ (\w+):
          .*If\ the\ current\ value\ is\ 0:
          .*Write\ the\ value\ (\d)\.
          .*Move\ one\ slot\ to\ the\ (\w+)\.
          .*Continue\ with\ state\ (\w+)\.
          .*If\ the\ current\ value\ is\ 1:
          .*Write\ the\ value\ (\d)\.
          .*Move\ one\ slot\ to\ the\ (\w+)\.
          .*Continue\ with\ state\ (\w+)\.
        /mx
        |> Regex.run(input |> String.split("\n") |> Enum.join(""))
        Map.put_new(states, state, %{
          0 => {String.to_integer(w0), offset(m0), c0},
          1 => {String.to_integer(w1), offset(m1), c1}
        })
    end)
    {initial, String.to_integer(steps), states}
  end

  def stream({initial, _, states}) do
    Stream.unfold({initial, %{}, 0, states}, fn
      {state, tape, cursor, states} ->
        {w, m, c} = Map.get(states, state) |> Map.get(Map.get(tape, cursor, 0))
        {tape, {c, Map.put(tape, cursor, w), cursor + m, states}}
    end)
  end

  def diagnostic(config, steps) do
    config
    |> TuringMachine.stream
    |> Enum.at(steps)
    |> Map.values
    |> Enum.sum
  end

  defp offset("right"), do: 1
  defp offset("left"), do: -1
end

config = {_, steps, _} = System.argv
|> hd
|> TuringMachine.parse
|> IO.inspect

# Part one
config
|> TuringMachine.diagnostic(steps)
|> IO.inspect
