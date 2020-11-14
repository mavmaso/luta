defmodule Luta.Repo.Migrations.AlterAddCharToArenas do
  use Ecto.Migration

  def change do
    alter table(:arenas) do
      add :char1_id, references(:fighters, on_delete: :nothing)
      add :char2_id, references(:fighters, on_delete: :nothing)
    end

    create index(:arenas, [:char1_id])
    create index(:arenas, [:char2_id])
  end
end
