defmodule KanbanWeb.HomePageLive do
  use Surface.LiveView
  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextInput}
  require Logger

  def mount(_params, _session, socket) do
    new_board = %Kanban.Board{title: ""}
    new_column = %Kanban.Column{title: "", id: 0}
    {:ok, 
      socket
      |> assign(board: new_board)
      |> assign(column: new_column)
      |> assign(columns: ["column1", "column2", "column3"])
    }
  end

  def render(assigns) do
    ~F"""
    <Form for={:board} change="update_board" opts={autocomplete: "off"}>
      <Field name="title">
        <Label/>
        <div class="control">
          <TextInput value={@board.title} />
        </div>
      </Field>
    </Form>
    <Form for={:column} change="update_column" opts={autocomplete: "off"}>
      {#for column <- @columns}
      <Field name={column}>
        <Label/>
        <div class="control">
          <TextInput value={@column.title} />
        </div>
      </Field>
      {/for}
    </Form>
    <button phx-click="create_board">Create board</button>
    """
  end
  
  def handle_event("update_board", %{"board" => %{"title" => new_title}}, socket) do
    {:noreply, 
      socket
      |> assign(board_name: new_title)
    }
  end

  def handle_event("update_column", params, socket) do
    %{"column" => columns} = params
    %{"column1" => column1, "column2" => column2, "column3" => column3} = columns
    {:noreply, 
      socket
      |> assign(first: column1)
      |> assign(second: column2)
      |> assign(third: column3)
    }
  end

  def handle_event("create_board", _params, socket) do
    new_board = Kanban.Repo.insert!(%Kanban.Board{title: socket.assigns.board_name})
    Logger.info(new_board)
    # column1 = Kanban.Repo.insert!(%Kanban.Column{title: socket.assigns.first, board_id: board.id})
    # in_progress = Kanban.Repo.insert!(%Kanban.Column{title: "In progress", board_id: board.id})
    # done = Kanban.Repo.insert!(%Kanban.Column{title: "Done", board_id: board.id})
    {:noreply, socket}
  end

end