defmodule Databases.Model.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Databases.Model

  schema "topics" do
    field :name_en, :string
    field :name_sv, :string
    has_many :database_topics, Model.DatabaseTopic 
  end

  def remap(%{} = topic, lang) do
    %{
      id: topic.id,
      name: Map.from_struct(topic)[String.to_existing_atom("name_" <> lang)] || topic.name_sv
    }
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end