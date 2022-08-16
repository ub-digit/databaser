defmodule DbListAdmin.Resource.Database.DatabaseTermsOfUse do
  alias DbListAdmin.Model
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabaseTermsOfUse.changeset(%Model.DatabaseTermsOfUse{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, Model.DatabaseTermsOfUse.remap(res)}
      {:error, error} -> {:error, Model.DatabaseTermsOfUse.remap_error(error.errors)}
    end
  end

  def insert_or_update(multi, atom_name, terms_of_use) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, terms_of_use)
    end)
  end

  def delete_all_terms_of_use(multi) do
    multi
    |> Multi.delete_all(:delete_all_terms_of_use, fn %{database: %{id: database_id}} ->
      (from terms_of_use in Model.DatabaseTermsOfUse,
      where: terms_of_use.database_id == ^database_id)
    end)
  end

  def remove_add_all(multi, data) do
    # delete all terms_of_use associated wid database with id
    multi = delete_all_terms_of_use(multi)
    data
    |> Model.DatabaseTermsOfUse.deserialize_terms_of_use()
    |> Enum.with_index()
    |> Enum.map(fn {val, index} ->
      atom_name = String.to_atom("terms_of_use_" <> Integer.to_string(index))
      {val, atom_name}
    end)
    |> Enum.reduce(multi, fn {terms_of_use, atom_name}, acc ->
        insert_or_update(acc, atom_name, terms_of_use)
    end)
  end
end
