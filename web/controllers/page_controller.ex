defmodule MazeGame.PageController do
  use MazeGame.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
