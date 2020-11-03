defmodule Luta.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Luta.Auth.User{
          login: "login-#{Faker.Lorem.word()}",
          password: Bcrypt.hash_pwd_salt("123456")
        }
      end
    end
  end
end
