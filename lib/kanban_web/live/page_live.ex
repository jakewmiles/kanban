defmodule KanbanWeb.PageLive do
  use Surface.LiveView
  require Logger

  def mount(_params, %{"board_id" => board_id}, socket) do
    with {:ok, board} <- Kanban.Board.find(board_id) do
      {:ok,
        socket
        |> assign(board: board)
      }
    else
      {:error, _reason} -> {:ok, redirect(socket, to: "/error")}
    end
  end

  def render(assigns) do
    ~F"""
    <h1> {@board.title}! </h1>
    """
  end
  
end