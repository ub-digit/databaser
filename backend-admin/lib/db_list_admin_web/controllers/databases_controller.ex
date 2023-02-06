defmodule DbListAdminWeb.DatabasesController do
  use DbListAdminWeb, :controller
  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp


  def index(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def index(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Resource.Elastic.Search.get_databases_admin(params)
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
  def show(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, %{"id" => id}) do
    case Integer.parse(id) do
      {id, _} when is_integer(id) -> DbListAdmin.Resource.Database.show(id)
      _  -> %{error: ""}
    end
    |> json_return(conn)
  end

  def show(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def json_return(%{error: _} = msg, conn) do
    json Plug.Conn.put_status(conn, 404), msg
  end

  def json_return(msg, conn) do
    json conn, msg
  end

  def create(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end
  def create(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    json conn, DbListAdmin.Resource.Database.Create.create_or_update(params)
  end

  def create(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def delete(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def delete(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, %{"id" => id}) do
    {:ok, res} =  DbListAdmin.Resource.Database.Delete.delete(id)
    json conn, res
  end

  def delete(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end

  def new(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def new(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, _params) do
    json conn, DbListAdmin.Resource.Database.Remapper.remap_empty_database()
  end

  def new(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end
end
