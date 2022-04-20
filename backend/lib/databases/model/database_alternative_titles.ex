defmodule Databases.Model.DatabaseAlternativeTitle do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "database_alternative_titles" do
      field :title, :string
      belongs_to :database, Model.Database
      #belongs_to :alternative_title, Databases.Model.AlternativeTitle
    end

    def remap(%Databases.Model.DatabaseAlternativeTitle{} = alternative_title) do
      alternative_title.title
    end
  
    @doc false
    def changeset(database_publisher, attrs) do
        database_publisher
      |> cast(attrs, [:database_id, :publisher_id])
    end
  end
  