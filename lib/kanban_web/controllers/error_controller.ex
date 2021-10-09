defmodule KanbanWeb.ErrorController do
  use KanbanWeb, :controller
  import Phoenix.LiveView.Controller

  def index(conn, _params) do
    live_render(conn, KanbanWeb.ErrorPageLive)
  end
end
