defmodule MazeGame.MazeChannel do
  use Phoenix.Channel

  def join("mazes:default", _, socket) do
    MazeGame.Manager.get_game("default")
    socket = assign(socket, :game, "default")
    {:ok, socket}
  end

  def handle_in("get_maze", _payload, socket) do
    game = MazeGame.Manager.get_game(socket.assigns[:game])
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.get_maze_with_players(game)}
    broadcast! socket, "players", %{"players" => MazeGame.Game.get_players(game)}
    {:noreply, socket}
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.initial_maze}
    {:noreply, socket}
  end

  def handle_in("set_name", %{"name" => name}, socket) do
    game = MazeGame.Manager.get_game(socket.assigns[:game])
    if Map.has_key?(socket.assigns, :name) do
      MazeGame.Game.update_player(game, socket.assigns[:name], name)
    else
      MazeGame.Game.add_player(game, name)
    end
    socket = assign(socket, :name, name)
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.get_maze_with_players(game)}
    broadcast! socket, "players", %{"players" => MazeGame.Game.get_players(game)}
    {:noreply, socket}
  end
end
