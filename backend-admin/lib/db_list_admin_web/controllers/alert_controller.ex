defmodule DbListAdminWeb.AlertController do
  use DbListAdminWeb, :controller

  def show(conn, _params) do
    json conn, DbListAdmin.Resource.Alert.fetch()
  end

  def create_or_update(conn, params) do
    json conn, DbListAdmin.Model.Alert.set(params)
  end
end
