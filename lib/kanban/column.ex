defmodule Kanban.Column do
  use Ecto.Schema
  import Ecto.Changeset

  schema "columns" do
    field :title, :string
    field :board_id, :id

    timestamps()
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
