defmodule DbListAdmin.Model.DatabaseAlternativeTitle do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model

  schema "database_alternative_titles" do
    field :title, :string
    belongs_to :database, Model.Database
  end

  def remap(%Model.DatabaseAlternativeTitle{} = alternative_title) do
    alternative_title.title
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
    |> cast(attrs, [:database_id, :title])
  end
end
