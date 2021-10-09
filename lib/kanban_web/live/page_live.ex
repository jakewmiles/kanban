defmodule KanbanWeb.PageLive do
  use Surface.LiveView

  def mount(_params, %{"board_id" => board_id}, socket) do
    with {:ok, board} <- Kanban.Board.find(board_id) do
      {:ok,
        socket
        |> assign(:board, board)
      }
    else
      {:error, _reason} -> {:ok, redirect(socket, to: "/error")}
    end
    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <h1> Welcome! </h1>
    """
  end
  
end