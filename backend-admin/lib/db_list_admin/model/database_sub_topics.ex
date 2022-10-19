defmodule DbListAdmin.Model.DatabaseSubTopic do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model

  schema "database_sub_topics" do
    belongs_to :database, Model.Database
    belongs_to :sub_topic, Model.SubTopic
    field :is_recommended, :boolean
  end

  def changeset(database_sub_topics, attrs) do
      database_sub_topics
    |> cast(attrs, [:database_id, :sub_topic_id, :is_recommended])
  end
end
