defmodule KanbanWeb.PageLive do
  use Surface.LiveView
  alias KanbanWeb.AddCard
  require Logger

  def mount(_params, %{"board_id" => board_id}, socket) do
    with {:ok, board} <- Kanban.Board.find(board_id) do
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
      <div class="col-xs-4">
        <div class="panel panel-info">
          <div class="panel-heading">
            <h3 class="panel-title">{column.title}</h3>
          </div>
        <div class="panel-body">
          <div class="column" data-column-id={column.id}>
          {#for card <- column.cards}
            <div data-card-id={card.id} class="task alert alert-success" role="alert">
              <textarea phx-blur="update_card" phx-value-card={card.id}>{card.content}</textarea>
            </div>
          {/for}
            <AddCard id={column.id}/>
          </div>
        </div>
      </div>
    </div>
    {/for}
    </div>
    """
  end

  def handle_event("add_card", %{"column" => column_id}, socket) do
    {id, _} = Integer.parse(column_id)
    new_card = %Kanban.Card{column_id: id, content: "Something new"}
    Kanban.Repo.insert!(new_card)
    {:ok, new_board} = Kanban.Board.find(socket.assigns.board.id)
    KanbanWeb.Endpoint.broadcast(topic(new_board.id), "new_board", new_board)
    {:noreply, 
      socket
      |> assign(board: new_board)
    }
  end

  def handle_event("update_card", %{"card" => card_id, "value" => new_content}, socket) do
    {id, _} = Integer.parse(card_id)
    Kanban.Card.update(id, %{content: new_content})
    {:ok, new_board} = Kanban.Board.find(socket.assigns.board.id)
    KanbanWeb.Endpoint.broadcast(topic(new_board.id), "new_board", new_board)
    {:noreply,
      socket
      |> assign(board: new_board)
    }
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