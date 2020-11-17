defmodule Luta.Factory do
  use ExMachina.Ecto, repo: Luta.Repo

  use Luta.ArenaFactory
  use Luta.UserFactory
  use Luta.FighterFactory
  use Luta.MoveSetFactory
end
