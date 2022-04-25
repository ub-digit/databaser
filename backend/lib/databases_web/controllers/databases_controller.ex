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
      IO.inspect(payload, label: "paload ")
      database = Jason.encode!(Databases.Resource.Search.show(payload))
      text conn, database
    end

    def show(conn, %{"id" => id} = payload) do
      id = Map.get(payload, "id")
      lang = Map.get(payload, "payload")
      |> Jason.decode!
      |> Map.get("lang")
      IO.inspect(lang, label: "LANG")
      database = Jason.encode!(Databases.Resource.Search.show(%{"id" => id, "lang" => lang}))
      text conn, database
    end
    
    def get_lang (params) do
      payload = Jason.decode!(Map.get(params, "payload"))
      |> Map.get("lang")
    end
  end

