defmodule KanbanWeb.CardContent do
  use Surface.Component
  prop id, :string, required: true
  prop content, :string, required: true

  def render(assigns) do
    ~F"""
    <div data-card-id={@id} class="task alert alert-success" role="alert">
      <textarea phx-blur="update_card" phx-value-card={@id}>{@content}</textarea>
    </div>
    """
  end
  
end