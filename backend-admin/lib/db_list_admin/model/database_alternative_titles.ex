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

  def changeset(database_publisher, attrs) do
      database_publisher
    |> cast(attrs, [:database_id, :title])
  end
end
