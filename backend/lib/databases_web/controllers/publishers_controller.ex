defmodule DatabasesWeb.PublisherController do
    use DatabasesWeb, :controller
  
    def index(conn, _params) do
      #text conn, "db controller"
      databases = Jason.encode!(Databases.Resource.Database.list_publishers())
        text conn, databases
    end

    #def show(conn, %{"id" => id}) do
    #    database = Poison.encode!(Databases.Resource.Database.get_database!(id)#)
    #    #database = Model.get_database!(id)
    #    text conn, database
    #end
  end


  