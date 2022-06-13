defmodule Databases.Model.MediaType do
  use Ecto.Schema
  alias Databases.Model

  schema "media_types" do
    field :name_en, :string
    field :name_sv, :string
    has_many :database_media_types, Model.DatabaseMediaType
  end

  def remap(%Model.MediaType{} = media_type, "sv") do
    Map.put(media_type, :name, media_type.name_sv)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%Model.MediaType{} = media_type, "en") do
    Map.put(media_type, :name, media_type.name_en)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%{} = media_type) do
    %{
      id: media_type.id,
      name: media_type.name
    }
  end
end
