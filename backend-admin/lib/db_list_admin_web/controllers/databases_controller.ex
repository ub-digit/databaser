defmodule DbListAdminWeb.DatabasesController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.Database.get_databases()
  end

  def show(conn, %{"id" => id}) do
     json conn, DbListAdmin.Resource.Database.show(id)
  end

  def create(conn, params) do
    json conn, DbListAdmin.Resource.Database.Create.create_or_update(params)
  end

  def delete(conn, %{"id" => id}) do
    {:ok, res} =  DbListAdmin.Resource.Database.Delete.delete(id)
    json conn, res
  end
end
