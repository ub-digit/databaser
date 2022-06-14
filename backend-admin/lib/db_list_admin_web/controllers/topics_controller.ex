defmodule DbListAdminWeb.TopicsController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.Topic.get_topics()
  end

  def create(conn, params) do
    json conn, DbListAdmin.Resource.Topic.Create.create_or_update(params)
  end
end
