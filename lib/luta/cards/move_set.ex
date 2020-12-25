defmodule Luta.Cards.MoveSet do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,only: [:description, :power, :special, :type, :start_up]}
  schema "move_sets" do
    field :description, :string
    field :power, :integer
    field :special, :string
    field :type, :string
    field :start_up, :integer

    timestamps()
  end

  @required ~w(description type start_up)a
  @optional ~w(power special)a
  @doc false
  def changeset(move_set, attrs) do
    move_set
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
