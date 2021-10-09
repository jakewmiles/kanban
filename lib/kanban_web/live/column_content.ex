defmodule KanbanWeb.ColumnContent do
  use Surface.Component
  alias KanbanWeb.AddCard
  alias KanbanWeb.CardContent
  prop title, :string, required: true
  prop id, :string, required: true
  prop cards, :list, required: true
  prop column_count, :integer, required: true

  def render(assigns) do
    ~F"""
    <div class="col-xs-4">
      <div class="panel panel-info">
        <div class="panel-heading">
          <h3 class="panel-title">{@title}</h3>
        </div>
        <div class="panel-body">
          <div class="column" data-column-id={@id}>
          {#for card <- @cards}
            <CardContent colour_id={@id} id={card.id} content={card.content}/>
          {/for}
            <AddCard id={@id}/>
          </div>
        </div>
      </div>
    </div>
    """
  end
  
end