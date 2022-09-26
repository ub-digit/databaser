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
  alias DbListAdmin.Resource.Database.Remapper
  alias DbListAdmin.Resource.Database.InputValidator

  def create_or_update(data) do
    data
    |> Remapper.deserialize_topics()
    |> Remapper.deserialize_publishers()
    |> Remapper.deserialize_terms_of_use()
    |> InputValidator.validate_input()
    |> case do
      {:ok, data} -> process_database(data)
      {:error, reasons} -> %{error: reasons}
    end
  end

  def process_database(data) do
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
    data = DbListAdmin.Resource.Database.get_one(id)
    data
    |> DbListAdmin.Model.Database.remap()
    |> DbListAdmin.Resource.Elastic.add_to_index()

    data
    |> DbListAdmin.Resource.Database.Remapper.remap_one_database()
  end
end
