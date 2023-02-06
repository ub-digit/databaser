defmodule DbListAdmin.Model.AccessToken do
  alias DbListAdmin.Model
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  @default_expire_seconds 3600*24

  schema "access_tokens" do
    field :token, :string
    field :session_key, :string
    field :last_valid, :utc_datetime
    field :name, :string
    field :username, :string
  end

  def find({:session_key, session_key}) do
    from(a in Model.AccessToken, where: a.session_key == ^session_key)
    |> DbListAdmin.Repo.one
  end

  def find({:token, token}) do
    from(a in Model.AccessToken, where: a.token == ^token)
    |> DbListAdmin.Repo.one
  end

  def find({:id, id}) do
    from(a in Model.AccessToken, where: a.id == ^id)
    |> DbListAdmin.Repo.one
  end

  def find(id) when is_number(id), do: find({:id, id})

  def remove_expired_tokens do
    expire_threshold = expire_threshold_date()
    from(a in Model.AccessToken,
      where: a.last_valid < ^expire_threshold)
    |> DbListAdmin.Repo.delete_all()
  end

  def refresh(session_key) do
    find({:session_key, session_key})
    |> refresh_access_token()
  end

  defp refresh_access_token(nil), do: nil
  defp refresh_access_token(%Model.AccessToken{} = access_token) do
    access_token
    |> update_valid_changeset()
    |> DbListAdmin.Repo.update!()
  end

  def expire_threshold_date() do
    DateTime.utc_now()
    |> DateTime.add(-@default_expire_seconds, :second)
  end

  def new_changeset(token, session_key, name, username) do
    %Model.AccessToken{}
    |> cast(%{token: token, session_key: session_key, last_valid: DateTime.utc_now(), name: name, username: username}, [:token, :session_key, :last_valid, :name, :username])
  end

  def update_valid_changeset(access_token) do
    access_token
    |> cast(%{last_valid: DateTime.utc_now()}, [:last_valid])
  end
end
