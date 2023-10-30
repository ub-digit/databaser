
defmodule DbListAdmin.Resource.Database do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query


  def base_query do
    from (db in Model.Database)
  end

  def database_base() do
    preload_database_topics_query = from(database_topic in Model.DatabaseTopic)
    preload_topics_query = from(topic in Model.Topic)
    preload_database_sub_topics_query = from(database_sub_topic in Model.DatabaseSubTopic)
    preload_sub_topics_query = from(sub_topic in Model.SubTopic)
    preload_database_pulishers_query = from(database_publisher in Model.DatabasePublisher)
    preload_publisher_query = from(publisher in Model.Publisher, preload: [database_publishers: ^preload_database_pulishers_query])
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

  def get_databases_raw do
    start_time = System.monotonic_time(:millisecond)
    databases = load_databases()
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
