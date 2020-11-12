defmodule Luta.ArenaFactory do
  defmacro __using__(_opts) do
    quote do
      def arena_factory do
        %Luta.Battle.Arena{
          name: "nome-#{Faker.Lorem.word()}",
          status: "waiting",
          p1: build(:user),
          p2: build(:user),
        }
      end
    end
  end
end
