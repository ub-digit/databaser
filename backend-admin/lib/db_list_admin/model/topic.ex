defmodule DbListAdmin.Model.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model
  alias DbListAdmin.Repo

  schema "topics" do
    field :name_en, :string
    field :name_sv, :string
    field :alternative_names_en, :string
    field :alternative_names_sv, :string
    timestamps()
    has_many :database_topics, Model.DatabaseTopic
    has_many :sub_topics, Model.SubTopic
  end

  # From public
  def remap(%Model.Topic{name_sv: name} = topic, "sv") do
    Map.put(topic, :name, name)
    |> Map.put(:alternative_names, topic.alternative_names_sv)
    |> Map.delete(:alternative_names_sv)
    |> Map.delete(:alternative_names_en)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap()
  end

  def remap(%Model.Topic{name_en: name} = topic, "en") do
    Map.put(topic, :name, name)
    |> Map.put(:alternative_names, topic.alternative_names_en)
    |> Map.delete(:alternative_names_sv)
    |> Map.delete(:alternative_names_en)
    |> Map.delete(:name_sv)
    |> Map.delete(:name_en)
    |> remap()
  end

  # This remap is what is used in the indexing of the databases
  def remap(%{name: _} = topic) do
    %{
      id: topic.id,
      name: topic.name,
      alternative_names: get_alternative_names_list(topic.alternative_names)
    }
  end

  def remap(%{name_en: _} = topic) do
    %{
      id: topic.id,
      name_en: topic.name_en,
      name_sv: topic.name_sv,
      alternative_names_en: topic.alternative_names_en,
      alternative_names_sv: topic.alternative_names_sv,
      updated_at: topic.updated_at,
      sub_topics: Model.SubTopic.remap_all(topic.sub_topics),
      can_be_deleted: can_be_deleted(topic)
    }
  end

  def get_alternative_names_list(nil), do: []
  def get_alternative_names_list(alternative_names) do
    String.split(alternative_names, ",")
    |> Enum.map(fn str -> String.trim(str) end)
  end

  def can_be_deleted(%{:sub_topics => sub_topics} = topic) when is_list(sub_topics) do
    length(topic.sub_topics) < 1 and length(topic.database_topics) < 1
  end

  def can_be_deleted(_), do: false

  def remap_error(error) do
    error_list =
      error
      |> Enum.map(fn {k, {_, reason}} ->
        {r1, r2} = List.first(reason)
        %{:field => k, :error_code => Atom.to_string(r1) <> "_" <> Atom.to_string(r2)}
      end)

    %{
      error: %{
        topic: error_list
      }
    }
  end

  def find(id) when is_nil(id), do: %Model.Topic{}

  def find(id) do
    Repo.get!(Model.Topic, id)
  end

  @doc false
  def changeset(%Model.Topic{} = topic, attrs) do
    topic
    |> cast(attrs, [:name_en, :name_sv, :alternative_names_en, :alternative_names_sv])
    |> foreign_key_constraint(:sub_topics, name: :sub_topics_fk_topics)
    |> validate_required([:name_en, :name_sv])
    |> unique_constraint(:name_en, name: :topics_name_en_key)
    |> unique_constraint(:name_sv, name: :topics_name_sv_key)
  end
end
