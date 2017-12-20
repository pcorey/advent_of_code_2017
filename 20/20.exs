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

  def simulate_with_collisions(particles) do
    simulate_with_collisions(particles, 0)
  end

  def simulate_with_collisions(particles, 100) do
    particles
  end
  def simulate_with_collisions(particles, ticks) do
    particles
    |> Enum.reject(&collides?(&1, particles))
    |> Enum.map(&accelerate/1)
    |> Enum.map(&velocitate/1)
    |> simulate_with_collisions(ticks + 1)
  end

  defp distance([[px, py, pz], [vx, vy, vz], [ax, ay, az]], t) do
    dx = px + vx * t + 0.5 * ax * t * t
    dy = py + vy * t + 0.5 * ay * t * t
    dz = pz + vz * t + 0.5 * az * t * t
    abs(dx) + abs(dy) + abs(dz)
  end

  defp accelerate([pos, [vx, vy, vz], [ax, ay, az]]) do
    [pos, [vx + ax, vy + ay, vz + az], [ax, ay, az]]
  end

  defp velocitate([[px, py, pz], [vx, vy, vz], acc]) do
    [[px + vx, py + vy, pz + vz], [vx, vy, vz], acc]
  end

  defp collides?(particle = [[px, py, pz], _, _], particles) do
    particles
    |> Enum.reject(&(&1 == particle))
    |> Enum.any?(fn [[qx, qy, qz], _, _] -> px == qx && py == qy && pz == qz end)
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
|> elem(1)
|> IO.inspect

# Part two
particles
|> Particles.simulate_with_collisions
|> length
|> IO.inspect
