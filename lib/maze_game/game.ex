defmodule MazeGame.Game do
  alias MazeGame.Player

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def add_player(game, id) do
    location = [1,2]
    Agent.update(game, &Map.put(&1, id, %Player{name: id, location: location}))
  end

  def update_player(game, id, new_name) do
    Agent.update(game, fn game ->
      {player, new_game} = Map.pop(game, id)
      Map.put(new_game, new_name, %{player | name: new_name})
    end)
  end

  def get_players(game) do
    Agent.get(game, &(&1))
    |> Enum.map(fn {k, v} -> [k, v] end)
  end

  defp get_players_grouped_by_location(game) do
    Agent.get(game, &(&1))
    |> Enum.map(fn {k, v} -> v end)
    |> Enum.group_by(fn player -> player.location end)
  end

  defp get_players_for_location(game, location) do
    get_players_grouped_by_location(game)[location] || []
  end

  def get_maze_with_players(game) do
    rows = Enum.with_index(initial_maze)
    Enum.map(rows, fn {row, row_index} ->
      cells = Enum.with_index(row)
      Enum.map(cells, fn {cell, cell_index} ->
        %{cellType: cell, players: get_players_for_location(game, [cell_index, row_index])}
      end)
    end)
  end

  defp initial_maze do
    [[:wall, :finish, :wall],
     [:wall, :space, :wall],
     [:wall, :start, :wall]]
  end
end
