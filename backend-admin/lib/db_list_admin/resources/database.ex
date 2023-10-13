
defmodule DbListAdmin.Resource.Database do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query

  def old_database_base() do
    (from db in Model.Database,
    left_join: db_topics in Model.DatabaseTopic,
    on: db_topics.database_id == db.id,
    left_join: topic in Model.Topic,
    on: topic.id == db_topics.topic_id,
    left_join: st_for in Model.DatabaseSubTopic,
    on: st_for.database_id == db.id,
    left_join: st in Model.SubTopic,
    on: st.id == st_for.sub_topic_id,
    left_join: db_pb in Model.DatabasePublisher,
    on: db_pb.database_id == db.id,
    left_join: pb in Model.Publisher,
    on: pb.id == db_pb.publisher_id,
    left_join: db_publisher in assoc(pb, :database_publishers),
    left_join: database_alternative_titles in Model.DatabaseAlternativeTitle,
    on: database_alternative_titles.database_id == db.id,
    left_join: database_urls in Model.DatabaseUrl,
    on: database_urls.database_id == db.id,
    left_join: database_terms_of_use in Model.DatabaseTermsOfUse,
    on: database_terms_of_use.database_id == db.id,
    left_join: mt_db in Model.DatabaseMediaType,
    on: mt_db.database_id == db.id,
    left_join: mt in Model.MediaType,
    on: mt.id == mt_db.media_type_id,
    preload: [database_topics: db_topics, topics: topic, database_sub_topics: st_for, sub_topics: st, database_alternative_titles: database_alternative_titles, database_terms_of_use: database_terms_of_use, database_urls: database_urls, database_media_types: mt_db, media_types: mt, database_publishers: db_pb, publishers: {pb, :database_publishers}])
  end

  def base_query do
    from (db in Model.Database)
  end

  def database_base() do
    preload_database_topics_query = from(database_topic in Model.DatabaseTopic)
    preload_topics_query = from(topic in Model.Topic)
    preload_database_sub_topics_query = from(database_sub_topic in Model.DatabaseSubTopic)
    preload_sub_topics_query = from(sub_topic in Model.SubTopic)
    preload_database_pulishers_query = from(database_publisher in Model.DatabasePublisher)
    preload_publisher_query = from(publisher in Model.Publisher)
    preload_database_alternative_titles_query = from(database_alternative_title in Model.DatabaseAlternativeTitle)
    preload_database_urls_query = from(database_url in Model.DatabaseUrl)
    preload_terms_of_use_query = from(database_terms_of_use in Model.DatabaseTermsOfUse)
    preload_database_media_types_query = from(database_media_type in Model.DatabaseMediaType)
    preload_media_types_query = from(media_type in Model.MediaType)

    q = base_query()
    from(db in q,
      preload:
      [
        database_topics: ^preload_database_topics_query,
        topics: ^preload_topics_query,
        database_publishers: ^preload_database_pulishers_query,
        publishers: ^preload_publisher_query,
        database_sub_topics: ^preload_database_sub_topics_query,
        sub_topics: ^preload_sub_topics_query,
        database_alternative_titles: ^preload_database_alternative_titles_query,
        database_urls: ^preload_database_urls_query,
        database_terms_of_use: ^preload_terms_of_use_query,
        database_media_types: ^preload_database_media_types_query,
        media_types: ^preload_media_types_query
        ])

  end

  def load_databases() do
    database_base()
    |> Repo.all(timeout: :infinity)
  end

  def old_load_databases() do
    old_database_base()
    |> Repo.all(timeout: :infinity)
  end

  def get_databases_raw do
    start_time = System.monotonic_time(:millisecond)
    databases = load_databases()
    end_time = System.monotonic_time(:millisecond)
    IO.inspect("DB query took #{(end_time - start_time)} ms")
    databases
  end

  def old_get_databases_raw() do
    start_time = System.monotonic_time(:millisecond)
    databases = old_load_databases()
    end_time = System.monotonic_time(:millisecond)
    IO.inspect("DB query took #{(end_time - start_time)} ms")
    databases
  end

  def get_databases(lang) do
    load_databases()
    |> Enum.map(fn db -> Model.Database.remap(db, lang) end)
  end
  def get_databases() do
    load_databases()
    |> Enum.map(fn db -> Model.Database.remap(db) end)
  end

  def show(id) do
    get_one(id)
    |> case do
      {:error, reason} -> %{error: reason}
      db -> DbListAdmin.Resource.Database.Remapper.remap_one_database(db)
    end
  end

  def get_one(id) do
    (from db in database_base(),
    where: db.id == ^id)
    |> Repo.one
    |> case do
      nil -> {:error, "No database with id: " <> to_string(id) <> " was found"}
      db  -> db
    end
  end
end
