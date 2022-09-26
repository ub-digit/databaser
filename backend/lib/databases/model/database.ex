defmodule Databases.Model.Database do
  use Ecto.Schema
  alias Databases.Model
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

  def remap(%Model.Database{description_en: description, title_en: title} = database, "en") do
    Map.put(database, :description, description)
    |> Map.put(:title, title)
    |> Map.delete(:description_en)
    |> Map.delete(:title_en)
    |> remap("en")
  end

  def remap(%Model.Database{description_sv: description, title_sv: title} = database, "sv") do
    Map.put(database, :description, description)
    |> Map.put(:title, title)
    |> Map.delete(:description_sv)
    |> Map.delete(:title_sv)
    |> remap("sv")
  end
  def remap(%{description: _, title: _} = database, lang) do
    %{
      id: database.id,
      title: database.title,
      description: database.description,
      is_popular: database.is_popular,
      recommended_in_topics: set_recommended_in(database.database_topics, :topic),
      recommended_in_sub_topics: set_recommended_in(database.database_sub_topics, :sub_topic),
      alternative_titles: database.database_alternative_titles |> Enum.map(&Databases.Model.DatabaseAlternativeTitle.remap/1),
      urls: database.database_urls |> Enum.map(fn item -> Databases.Model.DatabaseUrl.remap(item, database.title) end),
      publishers: database.publishers |> Enum.map(fn item -> Model.Publisher.remap(item) end),
      public_access: database.public_access,
      access_information_code: database.access_information_code,
      malfunction_message_active: database.malfunction_message_active,
      malfunction_message: database.malfunction_message,
      topics: database.topics |> Enum.map(fn item -> Model.Topic.remap(item, lang) end),
      sub_topics: database.sub_topics |> Enum.map(fn item -> Model.SubTopic.remap(item, lang) end),
      terms_of_use: database.database_terms_of_use |> Enum.map(fn item -> Model.DatabaseTermsOfUse.remap(item, lang) end),
      media_types: database.media_types |> Enum.map(fn item -> Model.MediaType.remap(item, lang) end),
      sanitized_title: Slugy.slugify(database.title)
    }
    |> sort_topics
  end

  def set_recommended_in(topics, type) do
    topics
    |> Enum.filter(fn tp -> tp.is_recommended end)
    |> Enum.map(fn tp -> Map.get(tp, type).id end)
  end

  def sort_topics(db) do
    db
    |> Map.put(:topics, Enum.map(db.topics, fn topic -> Map.put(topic, :sub_topics, Enum.filter(db.sub_topics, fn sub_topic -> sub_topic.topic_id == topic.id end)) end))
    |> Map.delete(:sub_topics)
  end
end
