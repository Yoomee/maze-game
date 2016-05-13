defmodule MazeGame.Game do
  alias MazeGame.Player

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def add_player(game, id) do
    location = [1,3]
    Agent.update(game, &Map.put(&1, id, %Player{name: id, location: location}))
  end

  def update_player(game, id, new_name) do
    Agent.update(game, fn game ->
      {player, new_game} = Map.pop(game, id)
      Map.put(new_game, new_name, %{player | name: new_name})
    end)
  end

  def update_player_direction(game, id, direction) do
    Agent.update(game, fn game ->
      {player, new_game} = Map.pop(game, id)
      Map.put(new_game, id, %{player | direction: direction})
    end)
  end

  def get_players(game) do
    Agent.get(game, &(&1))
    |> Enum.map(fn {k, v} -> [k, v] end)
  end

  defp get_players_grouped_by_location(game) do
    IO.inspect Agent.get(game, &(&1))
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

  def tick(game) do
    Agent.get_and_update(game, fn state ->
      players = Enum.map(state, fn {name, player} ->
         {name, tick_player(game, player)}
      end)
      {{}, Enum.into(players, %{})}
    end)
  end

  defp tick_player(game, player = %Player{direction: direction, location: location, solved: false}) do
    desired_location = move(direction, location)
    case enterable_cell?(desired_location) do
      true -> %{player | location: move(player.direction, player.location), move_count: (player.move_count + 1)}
      _ -> player
    end
  end
  defp tick_player(_game, player), do: player

  defp enterable_cell?([x, y]) do
    IO.puts("desired cell: #{x} #{y}")
    Enum.at(initial_maze, y)
    |> Enum.at(x)
    |> case  do
      :wall -> false
      :finish -> true 
      :space -> true 
      :start -> true 
      _ -> false
    end
  end

  defp move("up", [x, y]), do: [x, y-1]
  defp move("down", [x, y]), do: [x, y+1]
  defp move("left", [x, y]), do: [x+1, y]
  defp move("right", [x, y]), do: [x-1, y]

  defp initial_maze do
    [[:wall, :wall, :wall, :wall, :wall],
     [:wall, :space, :space, :finish, :wall],
     [:wall, :space, :wall, :wall, :wall],
     [:wall, :start, :wall],
     [:wall, :wall, :wall]]
  end
end
