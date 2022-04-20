defmodule Databases.Model.DatabasePublisher do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "database_publishers" do
      belongs_to :database, Model.Database
      belongs_to :publisher, Model.Publisher
    end
  
    @doc false
    def changeset(publisher_for, attrs) do
        publisher_for
      |> cast(attrs, [:database_id, :publisher_id])
    end
  end
  