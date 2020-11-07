defmodule Luta.Char.Fighter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fighters" do
    field :atk, :integer
    field :def, :integer
    field :hps, :integer
    field :spd, :integer
    field :title, :string

    belongs_to :user, Luta.Auth.User

    timestamps()
  end

  @doc false
  @required ~w(title atk def spd hps)a
  def changeset(fighter, attrs) do
    fighter
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
