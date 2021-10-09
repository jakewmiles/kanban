defmodule KanbanWeb.AddCard do
  use Surface.Component
  prop id, :string, required: true

  def render(assigns) do
    ~F"""
    <div>
      <button phx-value-column={@id} phx-click="add_card">Add card</button>
    </div>
    """
  end
  
end