defmodule Luta.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :login, :nick]}
  schema "users" do
    field :login, :string
    field :password, :string
    field :nick, :string

    timestamps()
  end

  @required ~w(login password nick)a
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint(:login)
    |> unique_constraint(:nick)
    |> put_password()
  end

  defp put_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password(changeset), do: changeset
end
