defmodule DbListAdmin.Model.DatabaseTopic do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model

  schema "database_topics" do
    belongs_to :database, Model.Database
    belongs_to :topic, Model.Topic
    field :is_recommended, :boolean
  end

  @doc false
  def changeset(database_topics, attrs) do
      database_topics
    |> cast(attrs, [:database_id, :topic_id, :is_recommended])
  end
end
