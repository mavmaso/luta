defmodule Luta.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias Luta.Repo

  alias Luta.Cards.MoveSet

  @doc """
  Returns the list of move_sets.

  ## Examples

      iex> list_move_sets()
      [%MoveSet{}, ...]

  """
  def list_move_sets do
    Repo.all(MoveSet)
  end

  @doc """
  Gets a single move_set.

  Raises `Ecto.NoResultsError` if the Move set does not exist.

  ## Examples

      iex> get_move_set!(123)
      %MoveSet{}

      iex> get_move_set!(456)
      ** (Ecto.NoResultsError)

  """
  def get_move_set!(id), do: Repo.get!(MoveSet, id)

  @doc """
  Creates a move_set.

  ## Examples

      iex> create_move_set(%{field: value})
      {:ok, %MoveSet{}}

      iex> create_move_set(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_move_set(attrs \\ %{}) do
    %MoveSet{}
    |> MoveSet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a move_set.

  ## Examples

      iex> update_move_set(move_set, %{field: new_value})
      {:ok, %MoveSet{}}

      iex> update_move_set(move_set, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_move_set(%MoveSet{} = move_set, attrs) do
    move_set
    |> MoveSet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a move_set.

  ## Examples

      iex> delete_move_set(move_set)
      {:ok, %MoveSet{}}

      iex> delete_move_set(move_set)
      {:error, %Ecto.Changeset{}}

  """
  def delete_move_set(%MoveSet{} = move_set) do
    Repo.delete(move_set)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking move_set changes.

  ## Examples

      iex> change_move_set(move_set)
      %Ecto.Changeset{data: %MoveSet{}}

  """
  def change_move_set(%MoveSet{} = move_set, attrs \\ %{}) do
    MoveSet.changeset(move_set, attrs)
  end

  def card_resolver(card_1, card_2) do
    start_1 = if is_nil(card_1), do: 0, else: card_1.start_up
    start_2 = if is_nil(card_2), do: 0, else: card_2.start_up

    prime =
      cond do
        start_1 - start_2 > 0 ->
          :p1
        start_2 - start_1 > 0 ->
          :p2
        start_1 == start_2 ->
          :draw
      end

    case prime do
      :p1 ->
        "algo"
      :p2 ->
        "outro"
      :draw ->
        "n sei"
    end
  end
end
