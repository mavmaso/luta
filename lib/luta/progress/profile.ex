defmodule Luta.Progress.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:defeats, :matches, :season, :victories, :user_id]}
  schema "profiles" do
    field :defeats, :integer
    field :matches, :integer
    field :season, :string
    field :victories, :integer

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
