defmodule Luta.Repo.Migrations.AlterAddWinnerLoserToArenas do
  use Ecto.Migration

  def change do
    alter table(:arenas) do
      add :winner, :string
      add :loser, :string
    end
  end
end
