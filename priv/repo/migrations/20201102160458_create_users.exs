defmodule Luta.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :password, :string

      timestamps()
    end

    create unique_index(:users, [:login])
  end
end
