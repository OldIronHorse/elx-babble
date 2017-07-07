defmodule Babble.Directory do
  use GenServer

  ## Client API
  
  @doc """
  Starts the directory server
  """
  def start_link do
    GenServer.start_link(__MODULE__,%{},[])
  end

  @doc """
  Lists the available conversations
  """
  def list(directory) do
    GenServer.call(directory, :list)
  end
  
  @doc """
  Creates a new conversation
  """
  def create(directory,title) do
    GenServer.cast(directory, {:create,title})
  end

  ## GenServer callbacks

  def init(conversations) do
    {:ok,conversations}
  end

  def handle_call(:list,_from,conversations) do
    {:reply,Map.keys(conversations),conversations}
  end

  def handle_cast({:create,title},conversations) do
    {:noreply,Map.put(conversations,title,title)}
  end
end
