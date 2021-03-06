defmodule Babble.Conversation do
  use GenServer
  require Logger

  defmodule State do
    defstruct title: nil,posts: []
  end

  ## Client API
  
  @doc """
  Starts the conversation server
  """
  def start_link(title) do
    GenServer.start_link(__MODULE__,%State{title: title})
  end

  @doc """
  Join the conversation
  """
  def join(conversation,user) do
    GenServer.call(conversation,{:join,user})
  end

  @doc """
  Post a message
  """
  def post(conversation,text) do
    GenServer.cast(conversation,{:post,self(),text})
  end

  ## GenServer callbacks

  def init(%State{} = state) do
    {:ok,state}
  end

  def handle_call({:join,user},{from,_ref},state) do
    Registry.register(Babble.Conversation.Registry,state.title,{user,from})
    Logger.debug "Babble.Conversation.handle_cast :join, Registry.lookup: #{inspect(Registry.lookup(Babble.Conversation.Registry,state.title))}"
    Enum.each(Registry.lookup(Babble.Conversation.Registry,state.title),
              fn({_pid,{_name,user_pid}}) -> Babble.User.joined(user_pid,state.title,user) end)
    posts_new = ["#{user} joined."|state.posts]
    {:reply,posts_new,%{state | posts: posts_new}}
  end

  def handle_cast({:post,user,text},state) do
    Logger.debug "Babble.Conversation.handle_cast :post, Registry.lookup: #{inspect(Registry.lookup(Babble.Conversation.Registry,state.title))}"
    [{_conv_pid,{user_name,_user_pid}}|_] = Enum.drop_while(Registry.lookup(Babble.Conversation.Registry,state.title),
                                                            fn({_conv_pid,{_user,user_pid}}) -> user_pid != user end)
    Enum.each(Registry.lookup(Babble.Conversation.Registry,state.title),
              fn({_pid,{_name,user_pid}}) -> Babble.User.posted(user_pid,state.title,user_name,text) end)
    {:noreply,%{state | posts: [text|state.posts]}}
  end
end
