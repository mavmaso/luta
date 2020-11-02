defmodule Luta.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Luta.Auth.User{
          login: "login-#{Faker.Lorem.word()}",
          password: "$2b$12$hUjirQ7m7nO2R/IHevnTfeQlYrZy6II2I55WAUNsEH3GQwYiQoEre"
        }
      end
    end
  end
end
