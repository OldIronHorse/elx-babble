defmodule Babble.User do
  use GenServer
  require Logger

  ## Client API

  @doc """
  Notification that another user has joined a conversation
  """
  def joined(user,conversation,joined_user) when is_binary(user) do
    [{pid,_}] = Registry.lookup(:user_reg,user)
    joined(pid,conversation,joined_user)
  end
  def joined(user,conversation,joined_user) do
    GenServer.cast(user,{:joined,conversation,joined_user})
  end

  @doc """
  Notification that a user has posted something
  """
  def posted(user,conversation,posted_user,text) when is_binary(user) do
    Logger.debug "Babble.User.posted(#{user},#{conversation},#{inspect(posted_user)},#{text})"
    [{pid,_}] = Registry.lookup(:user_reg,user)
    posted(pid,conversation,posted_user,text)
  end
  def posted(user,conversation,posted_user,text) do
    Logger.debug "Babble.User.posted(#{inspect(user)},#{conversation},#{inspect(posted_user)},#{text})"
    GenServer.cast(user,{:posted,conversation,posted_user,text})
  end
end
