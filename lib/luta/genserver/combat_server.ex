defmodule Luta.CombatServer do
  use GenServer

  alias Luta.{ETS, Cards}

  # API

  def start_link(arena_id), do: GenServer.start_link(__MODULE__, arena_id)

  def init(arena_id) do
    action_turn(arena_id)

    {:ok, arena_id}
  end

  # def fight(pid, arena_id) do
  #  GenServer.cast(pid, {:start, arena_id})
  # end

  def stop(pid), do: GenServer.cast(pid, :stop)

  # Callback

  # def handle_cast({:start, arena_id}, state) do
  #   # IO.puts "Foi ..."
  #   action_turn(arena_id)
  #   {:noreply, state}
  # end

  def handle_cast(:stop, state), do: {:stop, :normal, state}

  def handle_info({:turn, arena_id}, state) do
    # IO.puts "Important stuff in progress..."
    action_turn(arena_id)

    {:noreply, state}
  end

  defp action_turn(arena_id) do
    arena = Luta.Battle.get_arena!(arena_id)
    combat = Utils.combat_atom(arena_id)

    scena = ETS.lookup(combat, "scena")

    buffer_p1 = ETS.lookup(combat, "buffer_p1")
    {p1_action, list_1} = List.pop_at(buffer_p1, 0)
    ETS.insert_buffer(combat, list_1, :buffer_p1)

    buffer_p2 = ETS.lookup(combat, "buffer_p2")
    {p2_action, list_2} = List.pop_at(buffer_p2, 0)
    ETS.insert_buffer(combat, list_2, :buffer_p2)

    Cards.card_resolver(p1_action, p2_action) |> IO.inspect

    case arena.status do
      "closed" ->
        # IO.puts "para !!!!!!"
        :ok
      _ ->
        # IO.puts "loopppppp"
        ETS.insert_scena(combat, scena + 1)
        Process.send_after(self(), {:turn, arena_id}, 2_000)
    end
  end
end
