
defmodule DbListAdmin.Resource.Topic.Delete do
  alias DbListAdmin.Repo
  alias DbListAdmin.Model

  def delete(id) do
    topic = Repo.get!(Model.Topic, id)
    case Repo.delete topic do
      {:ok, struct}       -> {:ok, struct}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
