defmodule DbListAdminWeb.TopicsController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.Topic.get_topics()
  end

  def create(conn, params) do
    json conn, DbListAdmin.Resource.Topic.save(params)
  end

  def show(conn, %{"id" => id}) do
    json conn, DbListAdmin.Resource.Topic.show(id)
  end

  def delete(conn, params) do
    json conn, DbListAdmin.Resource.Topic.Delete.delete(params)
  end
end
