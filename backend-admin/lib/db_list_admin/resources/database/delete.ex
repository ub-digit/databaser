defmodule DbListAdmin.Resource.Database.Delete do
  alias DbListAdmin.Repo
  alias DbListAdmin.Model
  def delete(id) do
    database = Repo.get!(Model.Database, id)
    case Repo.delete database do
      {:ok, struct}       -> {:ok, %{id: Map.get(struct, :id)}}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
