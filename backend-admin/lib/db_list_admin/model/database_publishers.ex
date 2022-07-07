defmodule DbListAdmin.Model.DatabasePublisher do
  use Ecto.Schema
  alias DbListAdmin.Model
  import Ecto.Changeset

  schema "database_publishers" do
    belongs_to :database, Model.Database
    belongs_to :publisher, Model.Publisher
  end

  def changeset(database_publisher, attrs) do
    database_publisher
    |> cast(attrs, [:database_id, :publisher_id])
  end
end
