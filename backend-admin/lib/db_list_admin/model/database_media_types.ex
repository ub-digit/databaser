defmodule DbListAdmin.Model.DatabaseMediaType do
  use Ecto.Schema
  alias DbListAdmin.Model
  import Ecto.Changeset

  schema "database_media_types" do
    belongs_to :database, Model.Database
    belongs_to :media_type, Model.MediaType
  end

  def changeset(database_media_type, attrs) do
    database_media_type
    |> cast(attrs, [:database_id, :media_type_id])
  end
end
