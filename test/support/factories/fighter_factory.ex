defmodule Luta.FighterFactory do
  defmacro __using__(_opts) do
    quote do
      def fighter_factory do
        %Luta.Char.Fighter{
          title: "nome-#{Faker.Lorem.word()}",
          atk: Faker.random_between(0, 10),
          def: Faker.random_between(0, 10),
          hps: Faker.random_between(100, 200),
          spd: Faker.random_between(0, 10),
        }
      end
    end
  end
end
