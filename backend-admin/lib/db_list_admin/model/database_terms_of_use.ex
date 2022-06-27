defmodule DbListAdmin.Model.DatabaseTermsOfUse do
  use Ecto.Schema
  alias DbListAdmin.Model

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
end
