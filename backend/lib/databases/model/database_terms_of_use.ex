defmodule Databases.Model.DatabaseTermsOfUse do
    use Ecto.Schema
    alias Databases.Model

    schema "database_terms_of_use" do
      belongs_to :database, Model.Database
      field :code, :string
      field :description_en, :string
      field :description_sv, :string
      field :permitted, :boolean
    end

    def remap(%Model.DatabaseTermsOfUse{description_en: description} = database_terms_of_use, "en") do
      Map.put(database_terms_of_use, :description, description)
      |> Map.delete(:description_en)
      |> remap()
    end

    def remap(%Model.DatabaseTermsOfUse{description_sv: description} = database_terms_of_use, "sv") do
      Map.put(database_terms_of_use, :description, description)
      |> Map.delete(:description_sv)
      |> remap()
    end

    def remap(%{} = database_terms_of_use) do
      %{
        permitted: database_terms_of_use.permitted,
        description: database_terms_of_use.description,
        code: database_terms_of_use.code,
        id: database_terms_of_use.id
      }
    end
  end
