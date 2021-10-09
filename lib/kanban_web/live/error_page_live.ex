defmodule KanbanWeb.ErrorPageLive do
  use Surface.LiveView

  def mount(_params, _session, socket) do
    {:ok, 
      socket
    }
  end

  def render(assigns) do
    ~F"""
    <h1> Error! </h1>
    """
  end


end