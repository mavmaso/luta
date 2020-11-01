defmodule Luta.Repo.Migrations.CreateArenas do
  use Ecto.Migration

  def change do
    create table(:arenas) do
      add :name, :string

      timestamps()
    end

  end
end
