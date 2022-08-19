
defmodule DbListAdmin.Resource.MediaType do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query
  alias Ecto.Multi



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
    Model.MediaType.find(id)
    |> case do
      nil -> %{error: "No media type with id " <> id <> " was found."}
      val -> Model.MediaType.remap(val)
    end
  end

  def create_or_update(data) do
    Model.MediaType.changeset(Model.MediaType.find(data["id"]), data)
    |> Repo.insert_or_update()
    |> case do
      {:ok, res} -> Model.MediaType.remap((res))
      {:error, reason} -> Model.MediaType.remap_error(reason.errors)
    end
  end

  def delete(data) do
    Multi.new()
    |> Multi.run(:media_type, fn repo, _ ->
      Model.MediaType.changeset(Model.MediaType.find(data["id"]), data)
      |> repo.delete()
      |> case do
        {:ok, res} -> {:ok, res}
        {:error, reason} -> {:error, Model.MediaType.remap_error(reason.errors)}
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
