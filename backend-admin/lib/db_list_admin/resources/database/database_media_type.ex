defmodule DbListAdmin.Resource.Database.DatabaseMediaType do
  alias DbListAdmin.Model
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabaseMediaType.changeset(%Model.DatabaseMediaType{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, res}
      {:error, error} -> {:error, error}
    end
  end

  def insert(multi, atom_name, media_type) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, media_type)
    end)
  end

  def remove_add_media_types(multi, data) do
    multi = remove_all_media_types(multi)
    data
    |> Enum.with_index()
    |> Enum.map(fn {media_type, index} ->
      atom_name = String.to_atom("media_type_" <> Integer.to_string(index))
      {%{"media_type_id" => Map.get(media_type, "id")}, atom_name}
    end)
    |> Enum.reduce(multi, fn {media_type, atom_name}, acc ->
        insert(acc, atom_name, media_type)
    end)
  end

  def remove_all_media_types(multi) do
    multi
    |> Multi.delete_all(:delete_all_media_types, fn %{database: %{id: database_id}} ->
      (from media_type in Model.DatabaseMediaType,
      where: media_type.database_id == ^database_id)
    end)
  end
end
