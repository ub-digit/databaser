defmodule DbListAdmin.Resource.Database.DatabasePublisher do
  alias DbListAdmin.Model
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabasePublisher.changeset(%Model.DatabasePublisher{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, res}
      {:error, error} -> {:error, error}
    end
  end

  def insert(multi, atom_name, publisher) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, publisher)
    end)
  end

  def remove_add_all(multi, data) do
    multi = remove_all_publishers(multi)
    data
    |> Enum.with_index()
    |> Enum.map(fn {publisher, index} ->
      atom_name = String.to_atom("publisher_" <> Integer.to_string(index))
      {%{"publisher_id" => Map.get(publisher, "id")}, atom_name}
    end)
    |> Enum.reduce(multi, fn {publisher, atom_name}, acc ->
        insert(acc, atom_name, publisher)
    end)
  end

  def remove_all_publishers(multi) do
    multi
    |> Multi.delete_all(:delete_all_publishers, fn %{database: %{id: database_id}} ->
      (from publisher in Model.DatabasePublisher,
      where: publisher.database_id == ^database_id)
    end)
  end
end
