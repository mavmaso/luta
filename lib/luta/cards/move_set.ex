defmodule Luta.Cards.MoveSet do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,only: [:description, :power, :size, :special, :type, :start_up, :hit_time]}
  schema "move_sets" do
    field :description, :string
    field :power, :integer
    field :size, :integer
    field :special, :string
    field :type, :string
    field :start_up, :integer
    field :hit_time, :integer

    timestamps()
  end

  @doc false
  def changeset(move_set, attrs) do
    move_set
    |> cast(attrs, [:type, :description, :size, :power, :special])
    |> validate_required([:type, :description, :size, :power, :special])
  end
end
