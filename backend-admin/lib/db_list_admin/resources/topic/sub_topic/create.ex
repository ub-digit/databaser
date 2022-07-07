defmodule DbListAdmin.Resource.Topic.SubTopic.Create do
  alias DbListAdmin.Model
  alias Ecto.Multi

  def create(repo, topic_id, data) do
    data = Map.put(data, "topic_id", topic_id)
    cs = Model.SubTopic.changeset(Model.SubTopic.find(data["id"]), data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, Model.SubTopic.remap(res)}
      {:error, error} -> {:error, Model.SubTopic.remap_error(error.errors)}
    end
  end

  def insert_or_update(multi, atom_name, sub_topic) do
    multi
    |> Multi.run(atom_name, fn repo, %{topic: %{id: topic_id}} ->
      create(repo, topic_id, sub_topic)
    end)
  end

  def delete(multi, atom_name, id) do
    multi
    |> Multi.run(atom_name, fn repo, _ ->
      Model.SubTopic.delete(repo, id)
    end)
  end

  def insert_update_delete_all(multi, data) do
    data
    |> Enum.with_index()
    |> Enum.map(fn {val, index} ->
      atom_name = String.to_atom("sub_topic_" <> Integer.to_string(index))
      {val, atom_name}
    end)
    |> Enum.reduce(multi, fn {sub_topic, atom_name}, acc ->
      case sub_topic do
        %{"id" => id, "delete" => true} -> delete(acc, atom_name, id)
        _ -> insert_or_update(acc, atom_name, sub_topic)
      end
    end)
  end
end
