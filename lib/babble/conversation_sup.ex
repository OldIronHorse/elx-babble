defmodule Babble.ConversationSup do
  use Supervisor

  @name Babble.ConversationSup

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_conversation(title) do
    Supervisor.start_child(@name,[title])
  end

  def init(:ok) do
    children = [worker(Babble.Conversation,[],restart: :temporary)]
    supervise(children,strategy: :simple_one_for_one)
  end
end
