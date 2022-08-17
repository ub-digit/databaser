
defmodule DbListAdmin.Resource.Topic.Create do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  alias Ecto.Multi
  alias DbListAdmin.Resource.Topic.SubTopic


  def create_or_update(%{"sub_topics" => _} = data) do
    Multi.new()
    |> Multi.run(:topic, fn repo, _ ->
      Model.Topic.changeset(Model.Topic.find(data["id"]), data)
      |> repo.insert_or_update()
      |> case do
        {:ok, res} -> {:ok, Model.Topic.remap(res)}
        {:error, reason} -> {:error, Model.Topic.remap_error(reason.errors)}
      end
    end)
    |> SubTopic.Create.insert_update_delete_all(data["sub_topics"])
    |> Repo.transaction()
    |> elem(1)
  end

  def create_or_update(data) do
    Map.put(data, "sub_topics", [])
    |> create_or_update()
  end
end
