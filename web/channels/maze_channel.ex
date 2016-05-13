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

  def handle_in("tick", _payload, socket) do
    game = MazeGame.Manager.get_game(socket.assigns[:game])
    MazeGame.Game.tick(game)
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.get_maze_with_players(game)}
    broadcast! socket, "players", %{"players" => MazeGame.Game.get_players(game)}
    broadcast! socket, "request_direction", %{}
    {:noreply, socket}
  end

  def handle_in("start_ticker", _payload, socket) do
    game = MazeGame.Manager.get_game(socket.assigns[:game])
    MazeGame.Ticker.start_link(game)
    {:noreply, socket}
  end

  def handle_in("direction", direction, socket) do
    game = MazeGame.Manager.get_game(socket.assigns[:game])
    if Map.has_key?(socket.assigns, :name) do
      MazeGame.Game.update_player_direction(game, socket.assigns[:name], direction)
    end
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
