defmodule KanbanWeb.ApiController do
  use KanbanWeb, :controller
  alias Kanban.Card

  @topic "boards"

  def update_card(conn, %{"id" => id, "target_column_id" => target_column_id}) do
    with {:ok, card} <- Card.update(id, %{column_id: target_column_id}) do
      new_board = card.column.board
      KanbanWeb.Endpoint.broadcast(
        KanbanWeb.PageLive.topic(new_board.id),
        "new_board",
        new_board
      )

      conn |> json(%{"id" => card.id})
    else
      {:error, _reason} -> conn |> json(%{"error" => "Could not update board"})
    end
  end
end