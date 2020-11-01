defmodule Luta.Battle.Arena do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name]}
  schema "arenas" do
    field :name, :string

    timestamps()
  end

  @required ~w(name)a
  @doc false
  def changeset(arena, attrs) do
    arena
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
  end
end
