defmodule DatabasesWeb.AlertController do
  use DatabasesWeb, :controller

  def show(conn, params) do
    json conn, Databases.Resource.Alert.fetch(params)
  end
end
