defmodule Luta.SocketTest do
  use LutaWeb.ChannelCase

  alias LutaWeb.{UserSocket}

  setup do
    {:ok}
  end

  describe "sockets" do
    test "primeiro" do
      {:ok, soc} = connect(UserSocket, %{id: "1"}) |> IO.inspect
      {:ok, _, soc} = subscribe_and_join(soc, ChatRoom, "room:chat")

      push(soc, "envia", %{msg: "Ola"})

      assert_push "recebe", %{msg: message}
      assert message.content == "Ola"
    end
  end
end
