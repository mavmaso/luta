defmodule Luta.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:login]}
  schema "users" do
    field :login, :string
    field :password, :string
    field :secret, :string, virtual: true

    timestamps()
  end

  @required ~w(login password)a
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint(:login)
    |> put_password()
  end

  defp put_password(%Ecto.Changeset{changes: %{secret: secret}} = changeset) do
    change(changeset, password: secret)
  end

  defp put_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password(changeset), do: changeset
end
