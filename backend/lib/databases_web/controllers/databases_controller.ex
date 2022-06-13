defmodule DatabasesWeb.DatabaseController do
  use DatabasesWeb, :controller

  def alert(conn, _params) do
    text conn, Jason.encode!(%{"en" => "english message", "sv" => "svenskt meddelande"})
  end

  def index(conn, params) do
    payload = case params do
      %{"payload" => p} -> Jason.decode!(p)
      _ -> %{}
    end
    databases = Jason.encode!(Databases.Resource.Search.search(payload))
    text conn, databases
  end

  def get_popular_databases(conn, params) do
    {databases, _} = Databases.Resource.Search.popular_databases(get_lang(params))
    text conn, Jason.encode!(databases)
  end


#TODO: payload  contain a "paload" object. Correct this in frontend
  def show(conn, %{"id" => _, "payload" => payload}) do
    database = Jason.encode!(Databases.Resource.Search.show(Jason.decode!((payload))))
    text conn, database
  end

  def get_lang (params) do
    Jason.decode!(Map.get(params, "payload"))
    |> Map.get("lang")
  end
end
