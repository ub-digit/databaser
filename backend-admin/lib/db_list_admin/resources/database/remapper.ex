defmodule DbListAdmin.Resource.Database.Remapper do
  alias DbListAdmin.Model
  alias DbListAdmin.Resource

  def remap_one_database(database) do
    database
    |> Model.Database.remap()
    |> serialize_topics()
    |> serialize_media_types()
    |> serialize_publishers()
  end

  def serialize_topics(db) do
    db_topics = db.topics

    topics = Resource.Topic.get_topics()
    |> Enum.map(fn topic ->
      Enum.map(db_topics, fn db_topic ->
        case topic.id == db_topic.id do
          true -> Map.put(topic, :selected, true) |> mark_sub_topics(db_topic)
          _ -> topic
        end
      end)
      |> List.first()
    end)
    Map.put(db, :topics, topics)
  end

  def mark_sub_topics(topic, %{sub_topics: []}), do: topic
  def mark_sub_topics(topic, db_topic) do
    topic
    |> Map.put(:sub_topics, Enum.map(topic.sub_topics, fn sub_topic ->
      Enum.map(db_topic.sub_topics, fn db_sub_topic ->
        case sub_topic.id == db_sub_topic.id do
          true -> Map.put(sub_topic, :selected, true)
          _ -> sub_topic
        end
      end)
      |> List.first()
    end))
  end

  # if database has no media types associated, provide full list with no selections
  def serialize_media_types(%{media_types: []} = db) do
    Map.put(db, :media_types, Resource.MediaType.get_media_types())
  end

  def serialize_media_types(db) do
    db_media_types = db.media_types
    media_types = Resource.MediaType.get_media_types()
    |> Enum.map(fn media_type ->
      Enum.map(db_media_types, fn db_media_type ->
        case media_type.id == db_media_type.id do
          true -> Map.put(media_type, :selected, true)
          _ -> media_type
        end
      end)
      |> List.first()
    end)
    Map.put(db, :media_types, media_types)
  end

  def serialize_publishers(db) do
    db_publishers = db.publishers
    publishers = Resource.Publisher.get_publishers()
    |> Enum.map(fn publisher ->
      Enum.map(db_publishers, fn db_publisher ->
        case publisher.id == db_publisher.id do
          true -> Map.put(publisher, :selected, true)
          _ -> publisher
        end
      end)
      |> List.first()
    end)
    Map.put(db, :publishers, publishers)
  end
end
