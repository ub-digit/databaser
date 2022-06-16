defmodule DbListAdminWeb.PublishersController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.Publisher.get_publishers()
  end

  def show(conn, params) do
    json conn, DbListAdmin.Resource.Publisher.show(params)
  end

  def create(conn, params) do
    json conn, DbListAdmin.Resource.Publisher.create_or_update(params)
  end

  def delete(conn, params) do
    json conn, DbListAdmin.Resource.Publisher.delete(params)
  end
end
