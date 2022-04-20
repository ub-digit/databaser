defmodule Databases.Model.DatabaseSubTopic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Databases.Model

  schema "database_sub_topics" do
    belongs_to :database, Model.Database
    belongs_to :sub_topic, Model.SubTopic
    field :is_recommended, :boolean
  end

  @doc false
  def changeset(database_topics, attrs) do
      database_topics
    |> cast(attrs, [:database_id, :topic_id_id])
  end
end
