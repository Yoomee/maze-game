defmodule MazeGame.Game do
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def add_player(game, id) do
    location = [2,1]
    Agent.update(game, &Map.put(&1, id, location))
  end

  def get_players(game) do
    Agent.get(game, &(&1))
    |> Enum.map(fn {k, v} -> [k, v] end)
  end

  def initial_maze do
    [[:wall, :finish, :wall],
     [:wall, :space, :wall],
     [:wall, :start, :wall]]
  end
end
