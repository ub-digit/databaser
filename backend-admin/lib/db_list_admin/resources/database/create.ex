defmodule DbListAdmin.Resource.Database.Create do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  alias Ecto.Multi
  alias DbListAdmin.Resource.Database.DatabaseUrl

  def create_or_update(data) do
    Multi.new()
    |> Multi.run(:database, fn repo, _ ->
      Model.Database.changeset(Model.Database.find(data["id"]), data)
      |> repo.insert_or_update()
      |> case do
        {:ok, res} -> {:ok, res}
        {:error, reason} -> {:error, Model.Database.remap_error(reason.errors)}
      end
    end)
    |> DatabaseUrl.delete_create_all(data["urls"])
    |> Repo.transaction()
    |> IO.inspect(label: "result")
    "Hey"
  end

  def result({_, res}) do
    #DbListAdmin.Resource.Database.show(%{"id" => id})
    IO.inspect(res, label: "RES")
  end
end
