defmodule DbListAdmin.Model.Database do
  use Ecto.Schema
  alias DbListAdmin.Repo
  alias DbListAdmin.Model
  import Ecto.Changeset

 # import Access

  schema "databases" do
    field :description_en, :string
    field :description_sv, :string
    field :title_en, :string
    field :title_sv, :string
    field :is_popular, :boolean
    field :public_access, :boolean
    field :access_information_code, :string
    field :malfunction_message_active, :boolean
    field :malfunction_message, :string
    has_many :database_publishers, Model.DatabasePublisher
    has_many :publishers, through: [:database_publishers, :publisher]
    has_many :database_topics, Model.DatabaseTopic
    has_many :topics, through: [:database_topics, :topic]
    has_many :database_sub_topics, Model.DatabaseSubTopic
    has_many :sub_topics, through: [:database_sub_topics, :sub_topic]
    has_many :database_alternative_titles, Model.DatabaseAlternativeTitle
    has_many :database_urls, Model.DatabaseUrl
    has_many :database_terms_of_use, Model.DatabaseTermsOfUse
    has_many :terms_of_use, through: [:database_terms_of_use, :terms_of_use]
    has_many :database_media_types, Model.DatabaseMediaType
    has_many :media_types, through: [:database_media_types, :media_type]
  end

  def remap(%{} = database) do
    %{
      id: database.id,
      title_en: database.title_en,
      title_sv: database.title_sv,
      description_en: database.description_en,
      description_sv: database.description_sv,
      is_popular: database.is_popular,
      recommended_in_topics: set_recommended_in(database.database_topics, :topic),
      reccomennded_in_sub_topics: set_recommended_in(database.database_sub_topics, :sub_topic),
      alternative_titles: database.database_alternative_titles |> Enum.map(&Model.DatabaseAlternativeTitle.remap/1),
      urls: database.database_urls |> Enum.map(&Model.DatabaseUrl.remap/1),
      publishers: database.publishers |> Enum.map(&Model.Publisher.remap/1),
      public_access: database.public_access,
      access_information_code: database.access_information_code,
      malfunction_message_active: database.malfunction_message_active,
      malfunction_message: database.malfunction_message,
      topics: database.topics |> Enum.map(&Model.Topic.remap/1),
      sub_topics: database.sub_topics |> Enum.map(&Model.SubTopic.remap/1),
      terms_of_use: database.database_terms_of_use |> Enum.map(&Model.DatabaseTermsOfUse.remap/1),
      media_types: database.media_types |> Enum.map(&Model.MediaType.remap/1),
      #sanitized_title: Slugy.slugify(database.title)
    }
    |> sort_topics
  end

  def remap_error(error) do
    error
  end

  def set_recommended_in(topics, type) do
    topics
    |> Enum.filter(fn tp -> tp.is_recommended end)
    |> Enum.map(fn tp ->
      case type do
        :topic -> Map.get(tp, :topic_id)
        :sub_topic -> Map.get(tp, :sub_topic_id)
      end
    end)
  end

  def sort_topics(db) do
    db
    |> Map.put(:topics, Enum.map(db.topics, fn topic -> Map.put(topic, :sub_topics, Enum.filter(db.sub_topics, fn sub_topic -> sub_topic.topic_id == topic.id end)) end))
    |> Map.delete(:sub_topics)
  end

  def find(id) when is_nil(id), do: %Model.Database{}
  def find(id) do
    Repo.get!(Model.Database, id)
  end

  def changeset(%Model.Database{} = database, attrs) do
    database
    |> cast(attrs, [
      :title_en,
      :title_sv,
      :description_en,
      :description_sv,
      :is_popular,
      :public_access,
      :access_information_code,
      :malfunction_message_active,
      :malfunction_message,
      ])
    |> validate_required([:title_en, :title_sv])
    |> unique_constraint(:title_en, name: :database_title_en_key)
    |> unique_constraint(:title_sv, name: :database_title_sv_key)
  end
end
