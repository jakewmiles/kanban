defmodule KanbanWeb.PageController do
  use KanbanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
