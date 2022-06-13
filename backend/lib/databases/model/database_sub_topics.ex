defmodule Databases.Model.DatabaseSubTopic do
  use Ecto.Schema
  alias Databases.Model

  schema "database_sub_topics" do
    belongs_to :database, Model.Database
    belongs_to :sub_topic, Model.SubTopic
    field :is_recommended, :boolean
  end
end
