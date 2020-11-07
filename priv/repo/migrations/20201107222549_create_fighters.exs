defmodule Luta.Repo.Migrations.CreateFighters do
  use Ecto.Migration

  def change do
    create table(:fighters) do
      add :title, :string
      add :atk, :integer
      add :def, :integer
      add :spd, :integer
      add :hps, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:fighters, [:user_id])
  end
end
