defmodule Luta.Repo.Migrations.CreateMoveSets do
  use Ecto.Migration

  def change do
    create table(:move_sets) do
      add :type, :string
      add :description, :string
      add :power, :integer
      add :special, :string
      add :start_up, :integer

      timestamps()
    end

  end
end
