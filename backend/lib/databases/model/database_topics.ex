defmodule Databases.Model.DatabaseTopic do
  use Ecto.Schema
  alias Databases.Model

  schema "database_topics" do
    belongs_to :database, Model.Database
    belongs_to :topic, Model.Topic
    field :is_recommended, :boolean
  end
end
