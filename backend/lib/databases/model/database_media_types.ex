defmodule Databases.Model.DatabaseMediaType do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "database_media_types" do
      belongs_to :database, Model.Database
      belongs_to :media_type, Model.MediaType   
    end
  
    @doc false
    def changeset(publisher_for, attrs) do
        publisher_for
      |> cast(attrs, [:database_id, :publisher_id])
    end
  end
  