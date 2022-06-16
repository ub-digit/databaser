defmodule DbListAdmin.Model.DatabaseMediaType do
  use Ecto.Schema
  alias DbListAdmin.Model

  schema "database_media_types" do
    #belongs_to :database, Model.Database
    belongs_to :media_type, Model.MediaType
  end
end
