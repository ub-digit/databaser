defmodule DbListAdminWeb.MediaTypesController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.MediaType.get_media_types()
  end

  def show(conn, params) do
    json conn, DbListAdmin.Resource.MediaType.show(params)
  end

  def create(conn, params) do
    json conn, DbListAdmin.Resource.MediaType.create_or_update(params)
  end

  def delete(conn, params) do
    json conn, DbListAdmin.Resource.MediaType.delete(params)
  end
end
