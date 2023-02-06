defmodule DbListAdmin.Resource.Auth do

  def authenticate(%{"username" => username, "password" => password}) do
    check_auth(username, password)
    |> fetch_userdata(username)
    |> create_session()
  end

  defp check_auth(username, password) do
    admin_username = System.get_env("ADMIN_USERNAME", "admin")
    admin_password = System.get_env("ADMIN_PASSWORD", "$2b$12$EE9UIj1hvmRNUAFw6Nn.ie6KFHyaUbt5U4t8S471O9QBR0yT0YqYm")

    case {username == admin_username, Bcrypt.verify_pass(password, admin_password)} do
      {true, true} -> {:ok, :login_success}
      _ -> {:error, :login_fail}
    end
  end

  defp fetch_userdata({:error, status}, _), do: {:error, status}
  defp fetch_userdata({:ok, :login_success}, username) do
    {:ok, %{"name" => System.get_env("ADMIN_NAME", "Administrator"), "username" => username}}
  end

  defp create_session({:error, status}), do: {:error, status}
  defp create_session({:ok, userdata}) do
    {_, access_token} = DbListAdmin.Resource.User.fetch_or_create("user-" <> UUID.uuid4, userdata)
    {:ok, userdata, access_token}
  end
end
