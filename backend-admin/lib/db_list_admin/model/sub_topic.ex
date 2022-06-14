defmodule DbListAdmin.Model.SubTopic do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model
  alias DbListAdmin.Repo

  schema "sub_topics" do
    field :name_en, :string
    field :name_sv, :string
    field :topic_id, :integer
    has_many :database_sub_topics, Model.DatabaseSubTopic
  end

  def remap(%Model.SubTopic{} = sub_topic) do

    %{
      id: sub_topic.id,
      topic_id: sub_topic.topic_id,
      name_en: sub_topic.name_en,
      name_sv: sub_topic.name_sv
    }
  end

  def remap_all(sub_topics) when is_list(sub_topics) do
    sub_topics
    |> Enum.map(fn item -> Model.SubTopic.remap(item) end)
  end

  def remap_all(_), do: []

  def remap_error(error) do
    error_list =
    error
    |> IO.inspect(label: "Error")
    |> Enum.map(fn {k, {_, reason}} ->
        {r1, r2} = List.first(reason)
        %{:field => k, :error_code => Atom.to_string(r1) <> "_" <> Atom.to_string(r2)}
      end)

    %{
      error: %{
        sub_topics: error_list
      }
    }
  end

  def find(id) when is_nil(id), do: %Model.SubTopic{}
  def find(id) do
    Repo.get!(Model.SubTopic, id)
  end

  def delete(repo, id) do
    repo.delete(%Model.SubTopic{id: id})
  end

  @doc false
  def changeset(%Model.SubTopic{} = sub_topic, attrs) do
    sub_topic
    |> cast(attrs, [:name_en, :name_sv, :topic_id])
    |> validate_required([:name_en, :name_sv])
    |> validate_required([:topic_id])
    |> unique_constraint(:name_en, name: :sub_topic_name_en)
    |> unique_constraint(:name_sv, name: :sub_topic_name_sv)
  end
end
