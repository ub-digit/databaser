
defmodule DbListAdmin.Resource.Database do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query

  def database_base() do
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

  def get_databases() do
    database_base()
    |> Repo.all()
    |> Enum.uniq()
    |> Enum.map(fn item -> Model.Database.remap(item) end)
  end

  def show(id) do
    (from db in database_base(),
    where: db.id == ^id)
    |> Repo.one
    |> case do
      nil -> %{error: "No database with id: " <> id <> " was found"}
      db  -> DbListAdmin.Resource.Database.Remapper.remap_one_database(db)
    end
  end
end
