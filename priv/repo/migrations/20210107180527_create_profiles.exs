defmodule Luta.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :matches, :integer
      add :victories, :integer
      add :defeats, :integer
      add :season, :string

      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:profiles, [:user_id])
  end
end
