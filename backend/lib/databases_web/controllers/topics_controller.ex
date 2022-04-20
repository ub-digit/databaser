defmodule DatabasesWeb.TopicController do
  use DatabasesWeb, :controller
  
  def index(conn, %{"lang" => lang}) do
    topics = Jason.encode!(Databases.Resource.Topic.get_topics(lang))
    text conn, topics
  end
end


  