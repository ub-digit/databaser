defmodule DbListAdmin.Resource.Database.DatabaseUrl do
  alias DbListAdmin.Model
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabaseUrl.changeset(%Model.DatabaseUrl{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, Model.DatabaseUrl.remap(res)}
      {:error, error} -> {:error, Model.DatabaseUrl.remap_error(error.errors)}
    end
  end

  def insert_or_update(multi, atom_name, url) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, url)
    end)
  end

  def delete_all_urls(multi) do
    multi
    |> Multi.delete_all(:delete_all_urls, fn %{database: %{id: database_id}} ->
      (from url in Model.DatabaseUrl,
      where: url.database_id == ^database_id)
    end)
  end

  def delete_create_all(multi, data) do
    # delete all urls associated wid database with id
    multi = delete_all_urls(multi)
    data
    |> Enum.with_index()
    |> Enum.map(fn {val, index} ->
      atom_name = String.to_atom("url_" <> Integer.to_string(index))
      {val, atom_name}
    end)
    |> Enum.reduce(multi, fn {url, atom_name}, acc ->
        insert_or_update(acc, atom_name, url)
    end)
  end

end
