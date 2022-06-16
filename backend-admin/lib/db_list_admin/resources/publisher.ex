
defmodule DbListAdmin.Resource.Publisher do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query


  def publishers_base do
    from publishers in Model.Publisher,
    left_join: db_publishers in Model.DatabasePublisher,
    on: publishers.id == db_publishers.publisher_id,
    preload: [database_publishers: db_publishers]
  end

  def get_publishers() do
    (from t in publishers_base())
    |> Repo.all()
    |> Enum.map(fn item -> Model.Publisher.remap(item) end)
  end

  def show(%{"id" => id}) do
    Repo.get!(Model.Publisher, id)
    #|> Repo.preload([:database_publishers])
    |> Model.Publisher.remap()
  end

  def create_or_update(data) do
    Model.Publisher.changeset(Model.Publisher.find(data["id"]), data)
    |> Repo.insert_or_update()
    |> case do
      {:ok, res} -> Model.Publisher.remap((res))
      {:error, reason} -> Model.Publisher.remap_error(reason.errors)
    end
  end

  def delete(%{"id" => id}) do
    publisher = Repo.get(Model.Publisher, id)
    case publisher do
      nil -> %{error: %{publisher: %{error_code: "does_not_exist", id: id}}}
      _   -> case Repo.delete publisher do
              {:ok, struct}       -> Model.Publisher.remap(struct)
              {:error, changeset} -> {:error, changeset}
      end
    end
  end
end
