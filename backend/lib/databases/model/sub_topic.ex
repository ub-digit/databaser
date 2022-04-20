defmodule Databases.Model.SubTopic do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "sub_topics" do
      field :name_en, :string
      field :name_sv, :string
      field :topic_id, :integer
      has_many :database_sub_topics, Model.DatabaseSubTopic 
    end
  
    def remap(%Model.SubTopic{} = sub_topic, lang) do
      %{
        id: sub_topic.id,
        topic_id: sub_topic.topic_id,
        name: Map.from_struct(sub_topic)[String.to_existing_atom("name_" <> lang)] || sub_topic.name_sv
      }
    end
  
    @doc false
    def changeset(topic, attrs) do
      topic
      |> cast(attrs, [:title])
      |> validate_required([:title])
    end
  end