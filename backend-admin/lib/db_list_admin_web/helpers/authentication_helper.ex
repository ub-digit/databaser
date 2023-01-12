defmodule DbListAdminWeb.AuthenticationHelper do
  def authenticated?(conn) do
    get_session_key_from_header(conn)
    |> check_session_valid?()
  end

  def fetch_authenticated_user(conn) do
    get_session_key_from_header(conn)
    |> DbListAdmin.Resource.User.fetch_user_from_session_key()
    |> case do
      nil -> {:error, :session_invalid}
      access_token -> {:ok, %{username: access_token.username, name: access_token.name}}
    end
  end

  defp check_session_valid?(nil), do: false
  defp check_session_valid?(session_key) do
    DbListAdmin.Resource.User.fetch_user_from_session_key(session_key) != nil
  end

  def get_session_key_from_header(conn) do
    # IO.inspect(conn.req_headers, label: "CONN")
    auth_header = Plug.Conn.get_req_header(conn, "authorization") |> List.first

    case Regex.split(~r":? +", auth_header || "", []) do
      ["Bearer", key] -> key
      _ -> nil
    end
  end


  def add_authorization_header(conn, session_key), do: Plug.Conn.merge_resp_headers(conn, [{"Authorization", "Bearer " <> session_key}])

  def set_auth_required(conn), do: Plug.Conn.put_status(conn, 401)

  def set_forbidden(conn), do: Plug.Conn.put_status(conn, 403)

  def validation_error(conn), do: Plug.Conn.put_status(conn, 422)

  def set_auth_required_on_error(conn, {:error, _}), do: set_auth_required(conn)
  #defp set_auth_required_on_error(conn, {:ok, _, _}), do: conn
end
