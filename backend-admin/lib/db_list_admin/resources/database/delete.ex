defmodule DbListAdmin.Resource.Database.Delete do
  alias DbListAdmin.Repo
  alias DbListAdmin.Model
  def delete(id) do
    database = Repo.get!(Model.Database, id)
    case Repo.delete database do
      {:ok, _}            -> delete_db_from_index(id)
      {:error, changeset} -> {:error, changeset}
    end
  end

  def delete_db_from_index(id) do
    DbListAdmin.Resource.Elastic.delete_from_index(id)
    {:ok, %{status: "deleted"}}
  end
end
