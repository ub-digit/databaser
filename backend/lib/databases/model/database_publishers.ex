defmodule Databases.Model.DatabasePublisher do
    use Ecto.Schema
    alias Databases.Model

    schema "database_publishers" do
      belongs_to :database, Model.Database
      belongs_to :publisher, Model.Publisher
    end
  end
