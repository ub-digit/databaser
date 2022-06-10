
defmodule Databases.Resource.Database do
  alias Databases.Model.Database
  alias Databases.Model
  alias Databases.Repo
  alias Databases.Model.Publisher
  import Ecto.Query

  def list_publishers do
    (from db in Model.Database,
    select: map(db, [:title_en, :description_en]))
    |> Repo.all
  end

  def get_database!(id, lang) do # Remove or keep for admin pages? - This is done in Databases.Resources.Search
    (from db in db_base(),
    where: db.id == ^id)
    |> Repo.one
    |> Databases.Model.Database.remap(lang)
  end

  def db_base() do
    res = (from db in Model.Database,
    left_join: db_topics in Model.DatabaseTopic,
    on: db_topics.database_id == db.id,
    left_join: t in Model.Topic,
    on: t.id == db_topics.topic_id,
    left_join: st_for in Model.DatabaseSubTopic,
    on: st_for.database_id == db.id,
    left_join: st in Model.SubTopic,
    on: st.id == st_for.sub_topic_id,
    left_join: db_pb in Databases.Model.DatabasePublisher,
    on: db_pb.database_id == db.id,
    left_join: pb in Databases.Model.Publisher,
    on: pb.id == db_pb.publisher_id,
    left_join: database_alternative_titles in Databases.Model.DatabaseAlternativeTitle,
    on: database_alternative_titles.database_id == db.id,
    left_join: database_urls in Model.DatabaseUrl,
    on: database_urls.database_id == db.id,
    left_join: database_terms_of_use in Model.DatabaseTermsOfUse,
    on: database_terms_of_use.database_id == db.id,
    left_join: mt_db in Databases.Model.DatabaseMediaType,
    on: mt_db.database_id == db.id,
    left_join: mt in Databases.Model.MediaType,
    on: mt.id == mt_db.media_type_id,
    preload: [:database_topics, :topics, :database_sub_topics, :sub_topics, :database_alternative_titles, :database_terms_of_use, :database_urls, :database_media_types, :media_types,  database_publishers: db_pb, publishers: pb])
  end

  def popular_databases(lang) do
    list_databases_with_lang(lang)
    |> Enum.filter(fn db -> db.is_popular == true end)
  end

  @doc """
  Runs at startup of Phoenix, called from lib/dblist/application.ex
  At startup, fetch all databases and index them in Solr
  """
  def init do
    list_databases_with_lang("en")
    |> Databases.Resource.Search.index_all("en")
    list_databases_with_lang("sv")
    |> Databases.Resource.Search.index_all("sv")
  end

  def list_databases_with_lang(lang) do
    db_base()
    |> Repo.all
    |> Enum.map(fn item -> Databases.Model.Database.remap(item,  lang) end)
  end

  def d do
    (from db in Model.Database,
    left_join: mt_db in Databases.Model.DatabaseMediaType,
    on: mt_db.database_id == db.id,
    left_join: mt in Databases.Model.MediaType,
    on: mt.id == mt_db.media_type_id,
    limit: 10,
    preload: [:database_media_types])
    |> Repo.all
  end

  def rec do
    (from db in Model.Database,
    left_join: t_for in Model.DatabaseTopic,
    on: t_for.database_id == db.id,
    left_join: t in Model.Topic,
    on: t.id == t_for.topic_id,
    limit: 10,
    preload: [:topics, :database_topics])
    |> Repo.all
  end
end
