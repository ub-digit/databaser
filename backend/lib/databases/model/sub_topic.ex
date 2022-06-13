defmodule Databases.Model.SubTopic do
  use Ecto.Schema
  alias Databases.Model

  schema "sub_topics" do
    field :name_en, :string
    field :name_sv, :string
    field :topic_id, :integer
    has_many :database_sub_topics, Model.DatabaseSubTopic
  end

  def remap(%Model.SubTopic{name_sv: name} = sub_topic, "sv") do
    Map.put(sub_topic, :name, name)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%Model.SubTopic{name_en: name} = sub_topic, "en") do
    Map.put(sub_topic, :name, name)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%{} = sub_topic) do
    %{
      id: sub_topic.id,
      topic_id: sub_topic.topic_id,
      name: sub_topic.name
    }
  end
end
