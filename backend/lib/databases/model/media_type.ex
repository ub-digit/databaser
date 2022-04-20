defmodule Databases.Model.MediaType do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "media_types" do
      field :name_en, :string
      field :name_sv, :string
      has_many :database_media_types, Model.DatabaseMediaType 
    end
  
    def remap(%Model.MediaType{} = media_type, lang \\ "sv") do
      %{
        id: media_type.id,
        name: Map.from_struct(media_type)[String.to_existing_atom("name_" <> lang)] || media_type.title_sv
      }
    end
  
    @doc false
    def changeset(publisher, attrs) do
      publisher
      |> cast(attrs, [:title])
      |> validate_required([:title])
    end
  end
  