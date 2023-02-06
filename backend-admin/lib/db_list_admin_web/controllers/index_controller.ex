defmodule DbListAdminWeb.IndexController do
  use DbListAdminWeb, :controller
  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp

  def reindex_admin_index(%Plug.Conn{private: %{ authenticated: false }} = conn, _) do
    conn
    |> AuthHelp.set_auth_required()
    |> json(%{error: "Not authorized"})
  end

  def reindex_admin_index(%Plug.Conn{private: %{ current_user: %{ username: _ }}} = conn, params) do
    reindex = Map.get(params, "reindex", false) == "true"
    case reindex do
      false -> json conn, %{error: "no reindexing done, pass '?reindex=true' "}
      true -> json conn, DbListAdmin.Resource.Elastic.Index.initialize()
    end
  end

  def reindex_admin_index(%Plug.Conn{private: %{ authenticated: true }} = conn, _) do
    conn
    |> AuthHelp.set_forbidden()
    |> json(%{error: "Forbidden"})
  end
end
