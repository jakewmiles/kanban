defmodule KanbanWeb.CardContent do
  use Surface.Component
  prop id, :string, required: true
  prop content, :string, required: true
  prop card, :struct, required: true
  require Logger

  def render(assigns) do
    ~F"""
    <div data-card-id={@id} class="task alert alert-success">
      <textarea phx-blur="update_card" phx-value-card={@id}>{@content}</textarea>
      <h3 class="delete-button" phx-value-to_delete={@id} phx-click="delete_card">⨯</h3>
    </div>
    """
  end
  
end