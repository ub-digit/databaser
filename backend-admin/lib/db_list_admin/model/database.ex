defmodule DbListAdmin.Model.Database do
  use Ecto.Schema
  alias DbListAdmin.Repo
  alias DbListAdmin.Model
  import Ecto.Changeset

  schema "databases" do
    field :description_en, :string
    field :description_sv, :string
    field :title_en, :string
    field :title_sv, :string
    field :is_popular, :boolean
    field :public_access, :boolean
    field :access_information_code, :string
    field :malfunction_message_active, :boolean
    field :malfunction_message_en, :string
    field :malfunction_message_sv, :string
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


  def remap(%Model.Database{description_en: description, title_en: title, malfunction_message_en: malfunction_message} = database, "en") do
    Map.put(database, :description, description)
    |> Map.put(:title, title)
    |> Map.put(:malfunction_message, malfunction_message)
    |> Map.delete(:description_en)
    |> Map.delete(:title_en)
    |> Map.delete(:malfunction_message_en)
    |> remap("en")
  end

  def remap(%Model.Database{description_sv: description, title_sv: title, malfunction_message_sv: malfunction_message} = database, "sv") do
    Map.put(database, :description, description)
    |> Map.put(:title, title)
    |> Map.put(:malfunction_message, malfunction_message)
    |> Map.delete(:description_sv)
    |> Map.delete(:title_sv)
    |> Map.delete(:malfunction_message_sv)
    |> remap("sv")
  end

  def remap(%{description: _, title: _} = database, lang) do
    %{
      id: database.id,
      title: database.title,
      description: database.description,
      is_popular: database.is_popular,
      alternative_titles: database.database_alternative_titles |> Enum.map(&DbListAdmin.Model.DatabaseAlternativeTitle.remap/1),
      urls: database.database_urls |> Enum.map(fn item -> DbListAdmin.Model.DatabaseUrl.remap(item, database.title) end),
      publishers: database.publishers |> Enum.map(fn item -> Model.Publisher.remap(item) end),
      public_access: database.public_access,
      access_information_code: database.access_information_code,
      malfunction_message_active: database.malfunction_message_active,
      malfunction_message: database.malfunction_message,
      topics: database.topics |> Enum.map(fn item -> Model.Topic.remap(item, lang) end) |> recommended(database.database_topics),
      sub_topics: database.sub_topics |> Enum.map(fn item -> Model.SubTopic.remap(item, lang) end) |> recommended_sub(database.database_sub_topics),
      terms_of_use: database.database_terms_of_use |> Enum.map(fn item -> Model.DatabaseTermsOfUse.remap(item, lang) end),
      media_types: database.media_types |> Enum.map(fn item -> Model.MediaType.remap(item, lang) end),
      sanitized_title: Slugy.slugify(database.title)
    }
    |> sort_topics
  end

  def remap(%{} = database) do
    %{
      id: database.id,
      title_en: database.title_en,
      title_sv: database.title_sv,
      description_en: database.description_en,
      description_sv: database.description_sv,
      is_popular: database.is_popular,
      alternative_titles: database.database_alternative_titles |> Enum.map(&Model.DatabaseAlternativeTitle.remap/1),
      urls: database.database_urls |> Enum.map(&Model.DatabaseUrl.remap/1),
      publishers: database.publishers |> Enum.map(&Model.Publisher.remap/1),
      public_access: database.public_access,
      access_information_code: database.access_information_code,
      malfunction_message_active: database.malfunction_message_active,
      malfunction_message_en: database.malfunction_message_en,
      malfunction_message_sv: database.malfunction_message_sv,
      topics: database.topics |> Enum.map(&Model.Topic.remap/1) |> recommended(database.database_topics),
      sub_topics: database.sub_topics |> Enum.map(&Model.SubTopic.remap/1) |> recommended_sub(database.database_sub_topics),
      terms_of_use: database.database_terms_of_use |> Enum.map(&Model.DatabaseTermsOfUse.remap/1),
      media_types: database.media_types |> Enum.map(&Model.MediaType.remap_for_database/1),
    }
    |> sort_topics
  end
  def recommended_sub(sub_topics, db_sub_topics) do
    Enum.map(sub_topics, fn sub_topic ->
      Enum.any?(db_sub_topics, fn db_sub_topic ->
        db_sub_topic.sub_topic_id == sub_topic.id && db_sub_topic.is_recommended
      end)
      |> case do
        true -> Map.put(sub_topic, :recommended, true)
        _ ->  Map.put(sub_topic, :recommended, false)
      end
    end)
  end
  def recommended(topics, db_topics) do
    Enum.map(topics, fn topic ->
      Enum.any?(db_topics, fn db_topic ->
        db_topic.topic_id == topic.id && db_topic.is_recommended
      end)
      |> case do
        true -> Map.put(topic, :recommended, true)
        _ ->  Map.put(topic, :recommended, false)
      end
    end)
  end


  def remap_error(error) do
    error_list =
    error
    |> Enum.map(fn {k, {_, reason}} ->
      {r1, r2} = List.first(reason)
      %{:field => k, :error_code => Atom.to_string(r1) <> "_" <> Atom.to_string(r2)}
    end)
    %{
      error: %{
      database: error_list
      }
    }
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
      :malfunction_message_en,
      :malfunction_message_sv
      ],
      [empty_values: [nil]])
    |> validate_required([:title_en, :title_sv])
    |> unique_constraint(:title_en, name: :databases_title_en_key)
    |> unique_constraint(:title_sv, name: :databases_title_sv_key)
  end
end
