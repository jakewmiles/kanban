# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kanban.Repo.insert!(%Kanban.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

board = Kanban.Repo.insert!(%Kanban.Board{title: "Awesome project"})

backlog = Kanban.Repo.insert!(%Kanban.Column{title: "Backlog", board_id: board.id})

in_progress = Kanban.Repo.insert!(%Kanban.Column{title: "In progress", board_id: board.id})
done = Kanban.Repo.insert!(%Kanban.Column{title: "Done", board_id: board.id})

card =
  Kanban.Repo.insert!(%Kanban.Card{
    content: "Put some nice cat picture on the homepage",
    column_id: backlog.id
  })
