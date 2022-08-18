
defmodule DbListAdmin.Resource.Topic.Delete do
  alias DbListAdmin.Repo
  alias DbListAdmin.Model
  alias Ecto.Multi

  def delete(data) do
    Multi.new()
    |> Multi.run(:topic, fn repo, _ ->
      Model.Topic.changeset(Model.Topic.find(data["id"]), data)
      |> repo.delete()
      |> case do
        {:ok, res} -> {:ok, res}
        {:error, reason} -> {:error, Model.Topic.remap_error(reason.errors)}
      end
    end)
    |> Repo.transaction()
    |> parse_result()
  end

  def parse_result(res) do
    res
    |> case do
      {:ok, _}            -> %{status: "deleted"}
      {:error, _, err, _} -> err
    end
  end
end
