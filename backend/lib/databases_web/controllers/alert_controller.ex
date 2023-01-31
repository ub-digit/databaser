defmodule DatabasesWeb.AlertController do
  use DatabasesWeb, :controller

  def show(conn, _params) do
    json conn, Databases.Resource.Alert.fetch()
  end
end
