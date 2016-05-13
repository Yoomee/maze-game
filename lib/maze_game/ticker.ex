defmodule MazeGame.Ticker do
  use GenServer

  @tick_rate 1000

  # Client

  def start_link(game) do
    IO.puts("starting ticker")
    GenServer.start_link(__MODULE__, {game, 0})
  end

  def current_tick(pid) do
    GenServer.call(pid, :current_tick)
  end

  # Server

  def init(state) do
    Process.send_after(self, :tick, @tick_rate)
    {:ok, state}
  end

  def handle_info(:tick, {game, tick_count}) do
    MazeGame.Game.tick(game)
    MazeGame.Endpoint.broadcast("mazes:default", "maze", %{"maze" => MazeGame.Game.get_maze_with_players(game)})
    MazeGame.Endpoint.broadcast("mazes:default", "players", %{"players" => MazeGame.Game.get_players(game)})
    MazeGame.Endpoint.broadcast("mazes:default", "request_direction", %{})
    new_tick_count = tick_count + 1
    IO.puts("ticking #{new_tick_count}")
    Process.send_after(self, :tick, @tick_rate)
    {:noreply, {game, new_tick_count}}
  end

  def handle_call(:current_tick, _from, state) do
    {:reply, state, state}
  end
end
