
defmodule DbListAdmin.Resource.MediaType do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query


  def media_types_base do
    from media_types in Model.MediaType,
    left_join: db_media_types in Model.DatabaseMediaType,
    on: media_types.id == db_media_types.media_type_id,
    preload: [database_media_types: db_media_types]
  end

  def get_media_types() do
    (from t in media_types_base())
    |> Repo.all()
    |> Enum.map(fn item -> Model.MediaType.remap(item) end)
  end

  def show(%{"id" => id}) do
    Repo.get!(Model.MediaType, id)
    #|> Repo.preload([:database_publishers])
    |> Model.MediaType.remap()
  end

  def create_or_update(data) do
    Model.MediaType.changeset(Model.MediaType.find(data["id"]), data)
    |> Repo.insert_or_update()
    |> case do
      {:ok, res} -> Model.MediaType.remap((res))
      {:error, reason} -> Model.MediaType.remap_error(reason.errors)
    end
  end

  def delete(%{"id" => id}) do
    media_type = Repo.get(Model.MediaType, id)
    case media_type do
      nil -> %{error: %{Media_typ: %{error_code: "does_not_exist", id: id}}}
      _   -> case Repo.delete media_type do
              {:ok, struct}       -> Model.MediaType.remap(struct)
              {:error, changeset} -> {:error, changeset}
      end
    end
  end
end
