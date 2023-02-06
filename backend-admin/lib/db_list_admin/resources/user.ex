defmodule DbListAdmin.Resource.User do
  alias DbListAdmin.Model
  import Ecto.Query


  def fetch_access_token(token) do
    Model.AccessToken.find({:token, token })
  end

  def fetch_user_from_session_key(nil), do: nil
  def fetch_user_from_session_key(session_key) do
    Model.AccessToken.expire_threshold_date()
    Model.AccessToken.find({:session_key, session_key })
  end

  def fetch_or_create(access_token, user) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:token, fn repo, %{} ->
      token = fetch_access_token(access_token)
      case token do
        %Model.AccessToken{} ->
          repo.update!(Model.AccessToken.update_valid_changeset(token))
        _ ->
          session_key = generate_session_key()
          repo.insert!(Model.AccessToken.new_changeset(access_token, session_key, user["name"], user["username"]))
      end
      {:ok, user}
    end)
    |> DbListAdmin.Repo.transaction()

    access_token = Model.AccessToken.find({:token, access_token})

    {user, access_token}
  end

  def refresh_token(session_key) do
    DbListAdmin.Model.AccessToken.remove_expired_tokens()
    DbListAdmin.Model.AccessToken.refresh(session_key)
  end

  def generate_session_key() do
    UUID.uuid4(:hex)
  end
end
