defmodule Luta.Repo.Migrations.AlterAddNickToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :nick, :string
    end
  end
end
