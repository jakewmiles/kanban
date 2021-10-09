defmodule KanbanWeb.CardContent do
  use Surface.Component
  prop id, :string, required: true
  prop content, :string, required: true
  prop card, :struct, required: true
  prop colour_id, :integer, required: true

  def mount(_params, _session, socket) do
    {:ok, 
      socket
      |> assign(colour: @colour_id)
    }
  end

  def render(assigns) do
    alert_type = case (rem(assigns.colour_id, 3)) do
      0 -> "alert-success"
      1 -> "alert-danger"
      2 -> "alert-warning"
    end
    ~F"""
    <div data-card-id={@id} 
        class={"task", 
              "alert", 
              alert_type,
              assigns.colour_id 
              }>
      <textarea phx-blur="update_card" phx-value-card={@id}>{@content}</textarea>
      <h3 class="delete-button" phx-value-to_delete={@id} phx-click="delete_card">⨯</h3>
    </div>
    """
  end
  
end