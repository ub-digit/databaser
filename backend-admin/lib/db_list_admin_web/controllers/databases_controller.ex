defmodule DbListAdminWeb.DatabasesController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.Database.get_databases()
  end

  def show(conn, params) do
    json conn, DbListAdmin.Resource.Database.show(params)
    json conn, "jada"
  end


  def create(conn, params) do
    json conn, DbListAdmin.Resource.Database.Create.create_or_update(params)
  end
end
