defmodule Kanban.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :title, :string
    has_many :columns, Kanban.Column

    timestamps()
  end

  def find(id) do
    case Kanban.Board |> Kanban.Repo.get(id) do
      nil -> {:error, :not_found}
      board -> {:ok, board |> Kanban.Repo.preload(columns: :cards)}
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
