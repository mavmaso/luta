defmodule Luta.ProfileFactory do
  defmacro __using__(_opts) do
    quote do
      def profile_factory do
        %Luta.Progress.Profile{
          season: "season-#{Faker.Lorem.word()}",
          matches: 100,
          victories: Faker.random_between(1, 10),
          defeats: Faker.random_between(1, 10),
          user: build(:user)
        }
      end
    end
  end
end
