defmodule DbListAdmin.Resource.Database.DatabaseAlternativeTitle do
  alias Ecto.Multi
  alias DbListAdmin.Model
  import Ecto.Query

  def create(repo, database_id, data) do
    data = Map.put(data, "database_id", database_id)
    cs = Model.DatabaseAlternativeTitle.changeset(%Model.DatabaseAlternativeTitle{}, data)
    repo.insert_or_update(cs)
    |> case do
      {:ok, res} -> {:ok, Model.DatabaseAlternativeTitle.remap(res)}
      {:error, error} -> {:error, Model.DatabaseAlternativeTitle.remap_error(error.errors)}
    end
  end

  def insert_or_update(multi, atom_name, alternative_title) do
    multi
    |> Multi.run(atom_name, fn repo, %{database: %{id: database_id}} ->
      create(repo, database_id, alternative_title)
    end)
  end

  def delete_all_alternative_titles(multi) do
    multi
    |> Multi.delete_all(:delete_all_alternative_titles, fn %{database: %{id: database_id}} ->
      (from alternative_title in Model.DatabaseAlternativeTitle,
      where: alternative_title.database_id == ^database_id)
    end)
  end

  def delete_create_all(multi, data) do
    # delete all alternative_titles associated wid database with id
    multi = delete_all_alternative_titles(multi)
    data
    |> Enum.with_index()
    |> Enum.map(fn {val, index} ->
      atom_name = String.to_atom("alternative_title_" <> Integer.to_string(index))
      {%{"title_en" => val["title_en"], "title_sv" => val["title_sv"], "is_hidden" => val["is_hidden"]}, atom_name}
    end)
    |> Enum.reduce(multi, fn {alternative_title, atom_name}, acc ->
        insert_or_update(acc, atom_name, alternative_title)
    end)
  end

end
