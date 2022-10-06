defmodule DbListAdminWeb.DatabasesController do
  use DbListAdminWeb, :controller

  def index(conn, params) do
    #json conn, DbListAdmin.Resource.Database.get_databases()
    term = Map.get(params, "term", "")
    json conn, DbListAdmin.Resource.Elastic.Search.get_databases_admin(term)
  end

  def show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id, _} when is_integer(id) -> DbListAdmin.Resource.Database.show(id)
      _  -> %{error: ""}
    end
    |> json_return(conn)
  end

  def json_return(%{error: _} = msg, conn) do
    json Plug.Conn.put_status(conn, 404), msg
  end

  def json_return(msg, conn) do
    json conn, msg
  end

  def create(conn, params) do
    json conn, DbListAdmin.Resource.Database.Create.create_or_update(params)
  end

  def delete(conn, %{"id" => id}) do
    {:ok, res} =  DbListAdmin.Resource.Database.Delete.delete(id)
    json conn, res
  end

  def new(conn, _params) do
    json conn, DbListAdmin.Resource.Database.Remapper.remap_empty_database()
  end
end
