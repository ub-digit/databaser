defmodule DatabasesWeb.DatabaseController do
    use DatabasesWeb, :controller

    def alert(conn, params) do
      elastic_url = System.get_env("ELASTIC_SEARCH_URL", "No sys env value found")
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
      databases = Jason.encode!(Databases.Resource.Search.popular_databases(get_lang(params)))
      text conn, databases
    end

    def show(conn, %{"id" => id, "lang" => lang} = payload) do
      database = Jason.encode!(Databases.Resource.Search.show(payload))
      text conn, database
    end

    def show(conn, %{"id" => id} = payload) do
      database = Jason.encode!(Databases.Resource.Search.show(payload))
      text conn, database
    end
    
    def get_lang (params) do
      payload = Jason.decode!(Map.get(params, "payload"))
      |> Map.get("lang")
    end
  end

