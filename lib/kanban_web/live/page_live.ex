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
          <div data-card-id={card.id} class="task alert alert-success" role="alert">{card.content}</div>
        {/for}
          <div>
            <button>Add card</button>
          </div>
        </div>
      </div>
    </div>
  </div>
    {/for}
    </div>
    """
  end
  
end