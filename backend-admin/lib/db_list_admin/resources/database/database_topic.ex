defmodule DbListAdmin.Resource.Database.DatabaseTopic do
  alias DbListAdmin.Model
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabaseTopic.changeset(%Model.DatabaseTopic{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, res}
      {:error, error} -> {:error, error}
    end
  end

  def insert(multi, atom_name, topic) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, topic)
    end)
  end

  def remove_add_all(multi, data) do
    multi = remove_all_topics(multi)
    data
    |> Enum.with_index()
    |> Enum.map(fn {topic, index} ->
      atom_name = String.to_atom("topic_" <> Integer.to_string(index))
      {%{"topic_id" => Map.get(topic, "id")}, atom_name}
    end)
    |> Enum.reduce(multi, fn {topic, atom_name}, acc ->
        insert(acc, atom_name, topic)
    end)
  end

  def remove_all_topics(multi) do
    multi
    |> Multi.delete_all(:delete_all_topics, fn %{database: %{id: database_id}} ->
      (from topic in Model.DatabaseTopic,
      where: topic.database_id == ^database_id)
    end)
  end
end
