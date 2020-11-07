defmodule Luta.Char do
  @moduledoc """
  The Char context.
  """

  import Ecto.Query, warn: false
  alias Luta.Repo

  alias Luta.Char.Fighter

  @doc """
  Returns the list of fighters.

  ## Examples

      iex> list_fighters()
      [%Fighter{}, ...]

  """
  def list_fighters do
    Repo.all(Fighter)
  end

  @doc """
  Gets a single fighter.

  Raises `Ecto.NoResultsError` if the Fighter does not exist.

  ## Examples

      iex> get_fighter!(123)
      %Fighter{}

      iex> get_fighter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fighter!(id), do: Repo.get!(Fighter, id)

  @doc """
  Creates a fighter.

  ## Examples

      iex> create_fighter(%{field: value})
      {:ok, %Fighter{}}

      iex> create_fighter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fighter(attrs \\ %{}) do
    %Fighter{}
    |> Fighter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fighter.

  ## Examples

      iex> update_fighter(fighter, %{field: new_value})
      {:ok, %Fighter{}}

      iex> update_fighter(fighter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fighter(%Fighter{} = fighter, attrs) do
    fighter
    |> Fighter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fighter.

  ## Examples

      iex> delete_fighter(fighter)
      {:ok, %Fighter{}}

      iex> delete_fighter(fighter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fighter(%Fighter{} = fighter) do
    Repo.delete(fighter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fighter changes.

  ## Examples

      iex> change_fighter(fighter)
      %Ecto.Changeset{data: %Fighter{}}

  """
  def change_fighter(%Fighter{} = fighter, attrs \\ %{}) do
    Fighter.changeset(fighter, attrs)
  end
end
