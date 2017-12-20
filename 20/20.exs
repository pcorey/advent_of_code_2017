defmodule Particles do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.replace(&1, ~r/p=<|>| v=<| a=<|>/, ""))
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(fn
      line ->
        line
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(3)
    end)
  end

  def simulate(particles, t) do
    particles
    |> Enum.map(fn
      particle ->
        distance(particle, t)
    end)
  end

  def distance([[px, py, pz], [vx, vy, vz], [ax, ay, az]], t) do
    dx = px + vx * t + 0.5 * ax * t * t
    dy = py + vy * t + 0.5 * ay * t * t
    dz = pz + vz * t + 0.5 * az * t * t
    abs(dx) + abs(dy) + abs(dz)
  end
end

particles = System.argv
|> List.first
|> Particles.parse

# Part one
particles
|> Particles.simulate(1000)
|> Enum.with_index
|> Enum.sort
|> List.first
|> IO.inspect
