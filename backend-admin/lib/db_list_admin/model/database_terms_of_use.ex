defmodule DbListAdmin.Model.DatabaseTermsOfUse do
  use Ecto.Schema
  alias DbListAdmin.Model
  import Ecto.Changeset

  schema "database_terms_of_use" do
    belongs_to :database, Model.Database
    field :code, :string
    field :description_en, :string
    field :description_sv, :string
    field :permitted, :boolean
  end

  def remap(%{} = database_terms_of_use) do
    %{
      permitted: database_terms_of_use.permitted,
      description_en: database_terms_of_use.description_en,
      description_sv: database_terms_of_use.description_sv,
      code: database_terms_of_use.code,
      id: database_terms_of_use.id
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
        terms_of_use: error_list
      }
    }
  end



  def changeset(database_terms_of_use, attrs) do
    database_terms_of_use
    |> cast(attrs, [:database_id, :code, :description_en, :description_sv, :permitted])
    |> validate_required([:code])
    |> validate_required([:permitted])
  end
end
