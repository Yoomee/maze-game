defmodule MazeGame.MazeChannel do
  use Phoenix.Channel

  def join("mazes:default", _, socket) do
    MazeGame.Manager.get_game("default")
    socket = assign(socket, :game, "default")
    {:ok, socket}
  end

  def handle_in("get_maze", _payload, socket) do
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.initial_maze}
    game = MazeGame.Manager.get_game(socket.assigns[:game])
    broadcast! socket, "players", %{"players" => MazeGame.Game.get_players(game)}
    {:noreply, socket}
  end

  def handle_in("move", %{"direction" => direction}, socket) do
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.initial_maze}
    {:noreply, socket}
  end

  def handle_in("set_name", %{"name" => name}, socket) do
    # broadcast! socket, "maze", %{"maze" => MazeGame.Game.initial_maze}
    game = MazeGame.Manager.get_game(socket.assigns[:game])
      |> MazeGame.Game.add_player(name)
    {:noreply, socket}
  end
end
