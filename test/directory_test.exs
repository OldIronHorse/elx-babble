defmodule DirectoyTest do
  use ExUnit.Case, async: true

  setup do
    {:ok,directory} = Babble.Directory.start_link()
    {:ok,directory: directory}
  end

  test "list conversations: initially empty", %{directory: directory} do
    assert Babble.Directory.list(directory) == []
  end

  test " add conversations", %{directory: directory} do
    Babble.Directory.create(directory,"Title")
    assert Babble.Directory.list(directory) == ["Title"]
  end
end

