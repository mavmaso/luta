defmodule Luta.Battle.Arena do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :p1_id, :char1_id, :p2_id, :char2_id, :status, :winner, :loser]}
  schema "arenas" do
    field :name, :string
    field :status, :string, default: "pending"
    field :winner, :string
    field :loser, :string

    belongs_to :p1, Luta.Auth.User, foreign_key: :p1_id
    belongs_to :char1, Luta.Char.Fighter, foreign_key: :char1_id

    belongs_to :p2, Luta.Auth.User, foreign_key: :p2_id
    belongs_to :char2, Luta.Char.Fighter, foreign_key: :char2_id


    timestamps()
  end

  @status ~w(pending open waiting fighting closed)

  @required ~w(name)a
  @optional ~w(status p1_id p2_id char1_id char2_id winner loser)a
  @doc false
  def changeset(arena, attrs) do
    arena
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_inclusion(:status, @status)
  end
end
