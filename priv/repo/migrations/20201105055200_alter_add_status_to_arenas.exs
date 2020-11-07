defmodule Luta.Repo.Migrations.AlterAddStatusToArenas do
  use Ecto.Migration

  def change do
    alter table(:arenas) do
      add :status, :string

      add :p1_id, references(:users, on_delete: :nothing)
      add :p2_id, references(:users, on_delete: :nothing)
    end

    create index(:arenas, [:p1_id])
    create index(:arenas, [:p2_id])
  end
end
