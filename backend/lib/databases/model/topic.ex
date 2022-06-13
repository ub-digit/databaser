defmodule Databases.Model.Topic do
  use Ecto.Schema
  alias Databases.Model

  schema "topics" do
    field :name_en, :string
    field :name_sv, :string
    has_many :database_topics, Model.DatabaseTopic
  end

  def remap(%Model.Topic{name_sv: name} = topic, "sv") do
    Map.put(topic, :name, name)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%Model.Topic{name_en: name} = topic, "en") do
    Map.put(topic, :name, name)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap
  end

  def remap(%{} = topic) do
    %{
      id: topic.id,
      name: topic.name
    }
  end
end
