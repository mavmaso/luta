defmodule Luta.MoveSetFactory do
  defmacro __using__(_opts) do
    quote do
      def move_set_factory do
        %Luta.Cards.MoveSet{
          type: "D",
          description: "desc-#{Faker.Lorem.word()}",
          power: Faker.random_between(1, 10),
          special: "special-#{Faker.Lorem.word()}",
          start_up: Faker.random_between(1, 5)
        }
      end
    end
  end
end
