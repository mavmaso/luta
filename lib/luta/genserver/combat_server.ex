defmodule Luta.CombatServer do
  use GenServer

  # alias Luta.Battle.Arena

  # API

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # action_turn(arena)
    {:ok, state}
  end

  def fight(pid, arena_id) do
   GenServer.cast(pid, {:start, arena_id})
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  # Callback

  def handle_cast({:start, arena_id}, state) do
    IO.puts "Foi ..."
    action_turn(arena_id)
    {:noreply, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_info({:turn, arena_id}, state) do
    IO.puts "Important stuff in progress..."
    action_turn(arena_id)
    {:noreply, state}
  end

  defp action_turn(arena_id) do
    arena = Luta.Battle.get_arena!(arena_id)

    case arena.status do
      "closed" ->
        IO.puts "para !!!!!!"
      "fighting" ->
        IO.puts "loopppppp"
        Process.send_after(self(), {:turn, arena_id}, 10_000)
    end
  end
end
