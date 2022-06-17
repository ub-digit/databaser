defmodule DbListAdmin.Model.DatabasePublisher do
  use Ecto.Schema
  alias DbListAdmin.Model

  schema "database_publishers" do
    #belongs_to :database, Model.Database
    belongs_to :publisher, Model.Publisher
  end
end
