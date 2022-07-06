defmodule DbListAdmin.Resource.Database.Create do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  alias Ecto.Multi
  alias DbListAdmin.Resource.Database.DatabaseUrl
  alias DbListAdmin.Resource.Database.DatabaseAlternativeTitle
  alias DbListAdmin.Resource.Database.DatabaseMediaType
  alias DbListAdmin.Resource.Database.DatabasePublisher
  alias DbListAdmin.Resource.Database.DatabaseTopic
  alias DbListAdmin.Resource.Database.DatabaseSubTopic
  alias DbListAdmin.Resource.Database.DatabaseTermsOfUse

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
    |> DatabaseTopic.remove_add_all(data["topics"])
    |> DatabaseSubTopic.remove_add_all(DatabaseSubTopic.get_sub_topics(data["topics"]))
    |> DatabaseTermsOfUse.remove_add_all(data["terms_of_use"])
    |> Repo.transaction()
    |> result()
  end

  def result({_, res}) do
    %{database: %{id: id}} = res
    DbListAdmin.Resource.Database.show(id)
  end
end
