defmodule MazeGame.Manager do
  def start_link do
    {ok, game} = MazeGame.Game.start_link
    Agent.start_link(fn -> %{"default" => game} end, name: __MODULE__)
  end

  def new_game(name) do
    {ok, game} = MazeGame.Game.start_link
    Agent.get_and_update(__MODULE__, fn game_list -> {{name, game}, Map.put(game_list, name, game)} end)
  end

  def get_game(name) do
    Agent.get(__MODULE__, fn game_list -> game_list[name] end)
  end

  def update_game(name, game) do
    Agent.update(__MODULE__, fn game_list -> %{game_list | name => game} end)
  end

  def game_list do
    Agent.get(__MODULE__, fn game_list -> Map.keys(game_list) end)
  end
end
