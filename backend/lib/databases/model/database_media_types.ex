defmodule Databases.Model.DatabaseMediaType do
  use Ecto.Schema
  alias Databases.Model

  schema "database_media_types" do
    belongs_to :database, Model.Database
    belongs_to :media_type, Model.MediaType
  end
end
