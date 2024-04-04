defmodule DbListAdmin.Model.MediaType do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model
  alias DbListAdmin.Repo

  schema "media_types" do
    field :name_en, :string
    field :name_sv, :string
    field :alternative_names_en, :string
    field :alternative_names_sv, :string
    has_many :database_media_types, Model.DatabaseMediaType
  end

  def remap(%Model.MediaType{} = media_type, "sv") do
    Map.put(media_type, :name, media_type.name_sv)
    |> Map.put(:alternative_names, media_type.alternative_names_sv)
    |> Map.delete(:alternative_names_sv)
    |> Map.delete(:alternative_names_en)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%Model.MediaType{} = media_type, "en") do
    Map.put(media_type, :name, media_type.name_en)
    |> Map.put(:alternative_names, media_type.alternative_names_en)
    |> Map.delete(:alternative_names_sv)
    |> Map.delete(:alternative_names_en)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%{name: _} = media_type) do
    %{
      id: media_type.id,
      name: media_type.name,
      alternative_names: get_alternative_names_list(media_type.alternative_names)
    }
  end

  def remap(%{name_en: _, name_sv: _} = media_type) do
    %{
      id: media_type.id,
      name_en: media_type.name_en,
      name_sv: media_type.name_sv,
      alternative_names_en: media_type.alternative_names_en,
      alternative_names_sv: media_type.alternative_names_sv,
      can_be_deleted: can_be_deleted(media_type)
    }
  end

  def get_alternative_names_list(nil), do: []
  def get_alternative_names_list(alternative_names) do
    String.split(alternative_names, ",")
    |> Enum.map(fn str -> String.trim(str) end)
  end

  def remap_for_database(media_type) do
    media_type
    |> remap()
    |> Map.put(:can_be_deleted, false)
  end

  def can_be_deleted(%{:database_media_types => db_media_types}) when is_list(db_media_types) do
    length(db_media_types) < 1
 end
#TODO this might not be correct.
 def can_be_deleted(_), do: true

  def remap_error(error) do
    error_list =
    error
    |> Enum.map(fn {k, {_, reason}} ->
        {r1, r2} = List.first(reason)
        %{:field => k, :error_code => Atom.to_string(r1) <> "_" <> Atom.to_string(r2)}
      end)

    %{
      error: %{
        media_type: error_list
      }
    }
  end

  def find(id) when is_nil(id), do: %Model.MediaType{}
  def find(id) do
    Repo.get!(Model.MediaType, id) |> Repo.preload([:database_media_types])
  end

  @doc false
  def changeset(%Model.MediaType{} = media_type, attrs) do
    media_type
    |> cast(attrs, [:name_en, :name_sv])
    |> validate_required([:name_en, :name_sv, :alternative_names_en, :alternative_names_sv])
    |> unique_constraint(:name_en, name: :media_types_name_en_key)
    |> unique_constraint(:name_sv, name: :media_types_name_sv_key)
    |> foreign_key_constraint(:database_media_types, name: :database_media_types_fk_media_types)
  end
end
