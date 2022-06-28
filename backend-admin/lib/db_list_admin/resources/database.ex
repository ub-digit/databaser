
defmodule DbListAdmin.Resource.Database do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query

  def database_base() do
    (from db in Model.Database,
    left_join: db_topics in Model.DatabaseTopic,
    on: db_topics.database_id == db.id,
    left_join: t in Model.Topic,
    on: t.id == db_topics.topic_id,
    left_join: st_for in Model.DatabaseSubTopic,
    on: st_for.database_id == db.id,
    left_join: st in Model.SubTopic,
    on: st.id == st_for.sub_topic_id,
    left_join: db_pb in Model.DatabasePublisher,
    on: db_pb.database_id == db.id,
    left_join: pb in Model.Publisher,
    on: pb.id == db_pb.publisher_id,
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
    preload: [:database_topics, :topics, :database_sub_topics, :sub_topics, :database_alternative_titles, :database_terms_of_use, :database_urls, :database_media_types, :media_types,  database_publishers: db_pb, publishers: pb])
  end

  def get_databases() do
    database_base()
    |> Repo.all()
    |> Enum.map(fn item -> Model.Database.remap(item) end)
  end

  def show(id) do

    (from db in database_base(),
    where: db.id == ^id)
    |> Repo.one
    |> DbListAdmin.Model.Database.remap()
  end
end
