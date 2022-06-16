
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

  def create_or_update(data) do
    Model.MediaType.changeset(Model.MediaType.find(data["id"]), data)
    |> Repo.insert_or_update()
    |> case do
      {:ok, res} -> {:ok, Model.MediaType.remap((res))}
      {:error, reason} -> {:error, Model.MediaType.remap_error(reason.errors)}
    end
  end

  def delete(id) do
    media_type = Repo.get!(Model.MediaType, id)
    case Repo.delete media_type do
      {:ok, struct}       -> {:ok, struct}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
