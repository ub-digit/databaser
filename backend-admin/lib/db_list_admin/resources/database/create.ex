defmodule DbListAdmin.Resource.Database.Create do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  alias Ecto.Multi
  alias DbListAdmin.Resource.Database.DatabaseUrl
  alias DbListAdmin.Resource.Database.DatabaseAlternativeTitle
  alias DbListAdmin.Resource.Database.DatabaseMediaType
  alias DbListAdmin.Resource.Database.DatabasePublisher



  def create_or_update(data) do
    Multi.new()
    |> Multi.run(:database, fn repo, _ ->
      Model.Database.changeset(Model.Database.find(data["id"]), data)
      |> repo.insert_or_update()
      |> case do
        {:ok, res} -> {:ok, res}
        {:error, reason} -> {:error, Model.Database.remap_error(reason.errors)}
      end
    end)
    |> DatabaseUrl.delete_create_all(data["urls"])
    |> DatabaseAlternativeTitle.delete_create_all(data["alternative_titles"])
    |> DatabaseMediaType.remove_add_media_types(data["media_types"])
    |> DatabasePublisher.remove_add_all(data["publishers"])
    |> Repo.transaction()
    |> result()
  end

  def result({_, res}) do
    %{database: %{id: id}} = res
    DbListAdmin.Resource.Database.show(id)
  end
end