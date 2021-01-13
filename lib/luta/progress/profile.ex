defmodule Luta.Progress.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:defeats, :matches, :season, :victories, :user_id]}
  schema "profiles" do
    field :defeats, :integer, default: 0
    field :matches, :integer, default: 0
    field :season, :string
    field :victories, :integer, default: 0

    belongs_to :user, Luta.Auth.User

    timestamps()
  end

  @doc false
  @required ~w(defeats matches season victories)a
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
