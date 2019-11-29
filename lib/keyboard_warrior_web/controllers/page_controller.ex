defmodule KeyboardWarriorWeb.PageController do
  use KeyboardWarriorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
