defmodule Luta.ProfileFactory do
  defmacro __using__(_opts) do
    quote do
      def profile_factory do
        %Luta.Progress.Profile{
          season: "season-#{Faker.Lorem.word()}",
          matches: 10,
          victories: 5,
          defeats: 5,
          user: build(:user)
        }
      end
    end
  end
end
