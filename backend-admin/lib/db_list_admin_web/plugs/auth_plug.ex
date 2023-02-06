
defmodule DbListAdminWeb.AuthPlug do
  alias Plug.Conn
  alias DbListAdminWeb.AuthenticationHelper, as: AuthHelp

  def init(_), do: nil

  def call(conn, _) do
    is_authenticated = AuthHelp.authenticated?(conn)
    user = userdata(conn, is_authenticated)
    # IO.inspect({is_authenticated, user}, label: "auth_plug")
    conn
    |> Conn.put_private(:authenticated, is_authenticated)
    |> Conn.put_private(:current_user, user)
  end

  def userdata(_, {:ok, user}), do: user
  def userdata(_, {:error, _}), do: nil
  def userdata(conn, true), do: userdata(conn, AuthHelp.fetch_authenticated_user(conn))
  def userdata(_, _), do: nil
end
