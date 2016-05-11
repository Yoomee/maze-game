defmodule MazeGame.MazeChannel do
  use Phoenix.Channel

  def join("mazes:default", %{"name" => name}, socket) do
    IO.puts name 
    MazeGame.Game.add_player(name)
    {:ok, socket}
  end
  
  def handle_in("get_maze", _payload, socket) do
    broadcast! socket, "maze", %{"maze" => MazeGame.Game.initial_maze}
    {:noreply, socket}
  end
end
