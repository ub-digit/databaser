defmodule DbListAdminWeb.PublishersController do
  use DbListAdminWeb, :controller
  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp

  def index(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def index(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, _params) do
    json conn, DbListAdmin.Resource.Publisher.get_publishers()
  end

  def index(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def show(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def show(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Resource.Publisher.show(params)
  end

  def show(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def create(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def create(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Resource.Publisher.create_or_update(params)
  end

  def create(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end


  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp

  def delete(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def delete(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Resource.Publisher.delete(params)
  end

  def delete(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end
end
