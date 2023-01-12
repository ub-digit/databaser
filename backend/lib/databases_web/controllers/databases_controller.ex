defmodule DatabasesWeb.DatabaseController do
  use DatabasesWeb, :controller

  def alert(conn, _params) do
    json conn, %{"en" => "english message", "sv" => "svenskt meddelande"}
  end

  def index(conn, params) do
    topic = get_topic(params)
    params = Map.put(params, "topic", topic)
    databases = Databases.Resource.Search.search(params)
    json conn, databases
  end

  def get_topic(params) when not is_map_key(params, "topic"), do: nil

  def get_topic(%{"topic" => nil}), do: nil

  def get_topic(%{"topic" => topic}) do
    Integer.parse(topic)
    |> elem(0)
  end

  def get_popular_databases(conn, %{"lang" => lang}) do
    {databases, _} = Databases.Resource.Search.popular_databases(lang)
    json conn, databases
  end


#TODO: payload  contain a "paload" object. Correct this in frontend
  def show(conn,  payload) do
    database = Databases.Resource.Search.show(payload)
    json conn, database
  end

end
