defmodule KanbanWeb.PageLive do
  use Surface.LiveView
  alias KanbanWeb.ColumnContent
  alias Kanban.Card
  alias Kanban.Board
  require Logger

  def mount(_params, %{"board_id" => board_id}, socket) do
    with {:ok, board} <- Board.find(board_id) do
      KanbanWeb.Endpoint.subscribe(topic(board_id))
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
    <h1> {@board.title} </h1>
    <div class="row">
    {#for column <- @board.columns}
      <ColumnContent title={column.title} id={column.id} cards={column.cards}/>
    {/for}
    </div>
    """
  end

  def handle_event("add_card", %{"column" => column_id}, socket) do
    {id, _} = Integer.parse(column_id)
    new_card = %Card{column_id: id, content: "Something new"}
    Kanban.Repo.insert!(new_card)
    {:ok, new_board} = Board.find(socket.assigns.board.id)
    KanbanWeb.Endpoint.broadcast(topic(new_board.id), "new_board", new_board)
    {:noreply, 
      socket
      |> assign(board: new_board)
    }
  end

  def handle_event("update_card", %{"card" => card_id, "value" => new_content}, socket) do
    {id, _} = Integer.parse(card_id)
    Card.update(id, %{content: new_content})
    {:ok, new_board} = Board.find(socket.assigns.board.id)
    KanbanWeb.Endpoint.broadcast(topic(new_board.id), "new_board", new_board)
    {:noreply,
      socket
      |> assign(board: new_board)
    }
  end

  def handle_event("delete_card", %{"to_delete" => id}, socket) do
    Logger.info(id)
    to_delete = Kanban.Repo.get(Card, id)
    Kanban.Repo.delete!(to_delete)
    {:ok, new_board} = Board.find(socket.assigns.board.id)
    KanbanWeb.Endpoint.broadcast(topic(new_board.id), "new_board", new_board)
    {:noreply,
      socket
      |> assign(board: new_board)
    }
    {:noreply, socket}
  end

  def handle_info(%{topic: message_topic, event: "new_board", payload: new_board}, socket) do
    cond do
      topic(new_board.id) == message_topic ->
        {:noreply,
          socket
          |> assign(board: Kanban.Repo.preload(new_board, columns: :cards))
        }
      true ->
        {:noreply, socket}
    end
  end

  def topic(board_id) do
    "board:#{board_id}"
  end
  
end