defmodule MazeGame.Player do
  defstruct name: "player", location: [0,0], direction: "up", move_count: 0, solved: false
end
