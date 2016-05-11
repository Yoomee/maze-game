defmodule MazeGame.Game do
  def start_link do
    Agent.start_link(fn -> MapSet.new end, name: __MODULE__)
  end

  def add_player(id) do
    item = {id, {2,1}}
    Agent.update(__MODULE__, &MapSet.put(&1, item))
  end

  def get_players do
    Agent.get(__MODULE__, &(&1))
  end

  def initial_maze do
    [[:wall, :finish, :wall],
     [:wall, :space, :wall],
     [:wall, :start, :wall]]
  end
end
