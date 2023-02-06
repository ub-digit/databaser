defmodule DbListAdminWeb.TopicsController do
  use DbListAdminWeb, :controller
  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp

  def index(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def index(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, _params) do
    json conn, DbListAdmin.Resource.Topic.get_topics()
  end

  def index(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
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
    json conn, DbListAdmin.Resource.Topic.save(params)
  end

  def create(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def show(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def show(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, %{"id" => id}) do
    json conn, DbListAdmin.Resource.Topic.show(id)
  end

  def show(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def delete(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def delete(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Resource.Topic.Delete.delete(params)
  end

  def delete(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end
end
