defmodule Luta.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Luta.Auth.User{
          login: "login-#{Faker.Lorem.word()}",
          password: "$2b$12$iWNYYuxNcQhaUuJ82jLKu..jbrQQl8..it6K5AvdVovOwDmLX2OVu"
        }
      end
    end
  end
end
