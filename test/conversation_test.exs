defmodule ConversationTest do
  use ExUnit.Case, async: true

  setup do
    {:ok,conversation} = Babble.Conversation.start_link("Title")
    {:ok,_} = Registry.start_link(:duplicate,Babble.Conversation)
    {:ok,conversation: conversation}
  end

  test "join a conversation", %{conversation: conversation} do
    assert Babble.Conversation.join(conversation,"Bill") == ["Bill joined."]
    assert Babble.Conversation.join(conversation,"Bob") == ["Bob joined.","Bill joined."]
    assert_received {:"$gen_cast",{:joined,"Title","Bob"}}
  end

  test "post a message", %{conversation: conversation} do
    Babble.Conversation.join(conversation,"Bill")
    Babble.Conversation.post(conversation,"A short message")
    assert_receive {:"$gen_cast",{:posted,"Title","Bill","A short message"}}
  end
end
