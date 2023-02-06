defmodule DbListAdminWeb.AlertController do
  use DbListAdminWeb, :controller
  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp

  def show(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def show(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, _params) do
    json conn, DbListAdmin.Resource.Alert.fetch()
  end

  def show(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def create_or_update(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def create_or_update(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Model.Alert.set(params)
  end

  def create_or_update(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end
end
