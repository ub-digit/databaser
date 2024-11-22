defmodule DbListAdmin.Model.DatabaseAlternativeTitle do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model

  schema "database_alternative_titles" do
    field :title_en, :string
    field :title_sv, :string
    field :is_hidden, :boolean, default: false
    belongs_to :database, Model.Database
  end

  def remap(%Model.DatabaseAlternativeTitle{title_en: title, is_hidden: is_hidden}, "en") do
    %{
      title: title,
      is_hidden: is_hidden
    }
  end

  def remap(%Model.DatabaseAlternativeTitle{title_sv: title, is_hidden: is_hidden}, "sv") do
    %{
      title: title,
      is_hidden: is_hidden
    }
  end

  def remap(%Model.DatabaseAlternativeTitle{} = alt_title) do
    %{
      title_en: alt_title.title_en,
      title_sv: alt_title.title_sv,
      is_hidden: alt_title.is_hidden
    }
  end

  def remap_error(error) do
    error_list =
    error
    |> Enum.map(fn {k, {_, reason}} ->
        {r1, r2} = List.first(reason)
        %{:field => k, :error_code => Atom.to_string(r1) <> "_" <> Atom.to_string(r2)}
      end)

    %{
      error: %{
        database_alternative_title: error_list
      }
    }
  end

  def changeset(database_publisher, attrs) do
      database_publisher
    |> cast(attrs, [:database_id, :title_en, :title_sv, :is_hidden], [empty_values: [nil]])
  end
end
