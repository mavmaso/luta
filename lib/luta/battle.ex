defmodule Luta.Battle do
  @moduledoc """
  The Battle context.
  """

  import Ecto.Query, warn: false
  alias Luta.Repo
  alias Luta.Battle.Arena

  @doc """
  Returns the list of arenas.

  ## Examples

      iex> list_arenas()
      [%Arena{}, ...]

  """
  def list_arenas do
    Repo.all(Arena)
  end

  @doc """
  Gets a single arena.

  Raises `Ecto.NoResultsError` if the Arena does not exist.

  ## Examples

      iex> get_arena!(123)
      %Arena{}

      iex> get_arena!(456)
      ** (Ecto.NoResultsError)

  """
  def get_arena!(id), do: Repo.get!(Arena, id)

  @doc """
  Creates a arena.

  ## Examples

      iex> create_arena(%{field: value})
      {:ok, %Arena{}}

      iex> create_arena(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_arena(attrs \\ %{}) do
    %Arena{}
    |> Arena.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a arena.

  ## Examples

      iex> update_arena(arena, %{field: new_value})
      {:ok, %Arena{}}

      iex> update_arena(arena, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_arena(%Arena{} = arena, attrs) do
    arena
    |> Arena.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a arena.

  ## Examples

      iex> delete_arena(arena)
      {:ok, %Arena{}}

      iex> delete_arena(arena)
      {:error, %Ecto.Changeset{}}

  """
  def delete_arena(%Arena{} = arena) do
    Repo.delete(arena)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking arena changes.

  ## Examples

      iex> change_arena(arena)
      %Ecto.Changeset{data: %Arena{}}

  """
  def change_arena(%Arena{} = arena, attrs \\ %{}) do
    Arena.changeset(arena, attrs)
  end

  def check_arena(%Arena{} = arena, status) do
    case arena.status == status do
      true -> {:ok, status}
      _ -> {:error, :not_yet}
    end
  end
end
