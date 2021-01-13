defmodule Luta.CombatResolverTest do
  use Luta.DataCase

  alias Luta.Combat

  import Luta.Factory

  @map %{
    combat: Utils.combat_atom(arena_id),
    p1_card: Cards.not_null(nil),
    p2_card: Cards.not_null(nil),
  }

  describe "resolver/1" do
    test "when flow :duel" do

    end
  end
end
