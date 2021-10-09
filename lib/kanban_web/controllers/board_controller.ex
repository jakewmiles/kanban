defmodule KanbanWeb.BoardController do
  use KanbanWeb, :controller
  import Phoenix.LiveView.Controller

  def show(conn, %{"id" => id}) do
    live_render(conn, KanbanWeb.BoardPageLive, session: %{"board_id" => id})
  end
end
