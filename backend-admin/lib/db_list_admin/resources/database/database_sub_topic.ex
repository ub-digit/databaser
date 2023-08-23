defmodule DbListAdmin.Resource.Database.DatabaseSubTopic do
  alias DbListAdmin.Model
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabaseSubTopic.changeset(%Model.DatabaseSubTopic{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, res}
      {:error, error} -> {:error, error}
    end
  end

  def insert(multi, atom_name, sub_topic) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, sub_topic)
    end)
  end

  def remove_add_all(multi, data) do
    multi = remove_all_sub_topics(multi)
    data
    |> Enum.with_index()
    |> Enum.map(fn {sub_topic, index} ->
      atom_name = String.to_atom("sub_topic_" <> Integer.to_string(index))
      {%{"sub_topic_id" => Map.get(sub_topic, "id"), "is_recommended" => Map.get(sub_topic, "recommended")}, atom_name}
    end)
    |> Enum.reduce(multi, fn {sub_topic, atom_name}, acc ->
        insert(acc, atom_name, sub_topic)
    end)
  end

  def remove_all_sub_topics(multi) do
    multi
    |> Multi.delete_all(:delete_all_sub_topics, fn %{database: %{id: database_id}} ->
      (from sub_topic in Model.DatabaseSubTopic,
      where: sub_topic.database_id == ^database_id)
    end)
  end

  def get_sub_topics(topics) do
    topics
    |> Enum.map(fn topic ->
      topic["sub_topics"]
    end)
    |> List.flatten()
  end
end
