defmodule DbListAdmin.Resource.Database.Remapper do
  alias DbListAdmin.Model
  alias DbListAdmin.Resource

  def remap_one_database(database) do
    database
    |> Model.Database.remap()
    |> serialize()
  end

  def remap_empty_database() do
    %{
      title_en: "",
      title_sv: "",
      description_en: "",
      description_sv: "",
      access_information_code: "freely_available",
      alternative_titles: [],
      public_access: false,
      recommended_in_sub_topics: [],
      recommended_in_topics: [],
      is_popular: false,
      malfunction_message: "",
      malfunction_message_active: false,
      topics: [],
      media_types: [],
      publishers: [],
      terms_of_use: [],
      urls: []
    }
    |> serialize()
  end

  def serialize(db) do
    db
    |> serialize_topics()
    |> serialize_media_types()
    |> serialize_publishers()
    |> serialize_terms_of_use()
  end

  def serialize_topics(db) do
    db_topics = db.topics
    topics = Resource.Topic.get_topics()
    |> Enum.map(fn topic ->
      case Enum.find(db_topics, fn db_tp -> db_tp.id == topic.id end) do
        nil -> topic
        hit -> Map.put(topic, :selected, true) |> mark_sub_topics(hit)
      end
    end)
    |> Enum.map(fn topic ->
      Enum.any?(db_topics, fn db_topic ->
        db_topic.id == topic.id && db_topic.recommended
      end)
      |> case do
        true -> Map.put(topic, :recommended, true)
        false -> Map.put(topic, :recommended, false)
      end
    end)
    Map.put(db, :topics, topics)
  end

  def mark_sub_topics(topic, %{sub_topics: _} = db_topic) do
    Map.put(topic, :sub_topics,
      Enum.map(topic.sub_topics, fn sub_topic ->
        case Enum.find(db_topic.sub_topics, fn db_sub_tp -> db_sub_tp.id == sub_topic.id end) do
          nil -> sub_topic
          _ -> Map.put(sub_topic, :selected, true) |> set_is_recommended_in_sub_topic(db_topic.sub_topics)
        end
      end)
    )
  end



  def mark_sub_topics(topic, _), do: topic

  def set_is_recommended_in_sub_topic(sub_topic, db_sub_topoics) do
    Enum.find(db_sub_topoics, fn db_sub_topic -> db_sub_topic.id == sub_topic.id end)
    |> Map.get(:recommended)
    |> case do
      true -> Map.put(sub_topic, :recommended, true)
      _ ->  Map.put(sub_topic, :recommended, false)
    end
  end


  def deserialize_topics(db) do
    topics = db["topics"]
    |> Enum.filter(fn topic -> topic["selected"] == true end)
    |> deserialize_sub_topics()
    Map.put(db, "topics", topics)
  end

  def deserialize_sub_topics(topics) do
    topics
    |> Enum.map(fn topic ->
      sub_topics = Enum.filter(topic["sub_topics"], fn sub_topic -> sub_topic["selected"] == true end)
      Map.put(topic, "sub_topics", sub_topics)
    end)
  end

  def deserialize_media_types(db) do
    media_types = db["media_types"]
    |> Enum.filter(fn media_type -> media_type["selected"] == true end)
    Map.put(db, "media_types", media_types)
  end

  def deserialize_terms_of_use(db) do
    tou = db["terms_of_use"]
    |> Enum.filter(fn t -> Map.get(t, "permitted") != "N/A" end)
    |> Enum.map(fn t ->
      case Map.get(t, "permitted") do
         "yes"  -> Map.put(t, "permitted", true)
         "no"   -> Map.put(t, "permitted", false)
      end
    end)
    Map.put(db, "terms_of_use", tou)
  end

  def serialize_terms_of_use(db) do
    tou = db.terms_of_use
    default_tou = Model.TermsOfUse.get_default_terms_of_use()
    |> Enum.map(fn default_tou ->
      state = Enum.filter(tou, fn t -> t.code == default_tou.code end)
      |> List.first()
      |> get_tou_state()
      Map.put(default_tou, :permitted, state)
    end)
    Map.put(db, :terms_of_use, default_tou)
  end

  def get_tou_state(tou) when is_nil(tou), do: "N/A"

  def get_tou_state(tou) do
    Map.get(tou, :permitted)
    |> case do
      true -> "yes"
      false -> "no"
    end
  end

  # if database has no media types associated, provide full list with no selections
  def serialize_media_types(%{media_types: []} = db) do
    Map.put(db, :media_types, Resource.MediaType.get_media_types())
  end

  def serialize_media_types(db) do
    db_media_types = db.media_types
    media_types = Resource.MediaType.get_media_types()
    |> Enum.map(fn default_media_type ->
      Enum.any?(db_media_types, fn db_type -> db_type.id == default_media_type.id end)
      |> case do
        true -> Map.put(default_media_type, :selected, true)
        _ -> default_media_type
      end
    end)
    Map.put(db, :media_types, media_types)
  end

  def serialize_publishers(%{publishers: []} = db) do
    Map.put(db, :publishers, Resource.Publisher.get_publishers())
  end

  def serialize_publishers(db) do
    db_publishers = db.publishers
    publishers = Resource.Publisher.get_publishers()
    |> Enum.map(fn default_publisher ->
      Enum.any?(db_publishers, fn db_publisher -> db_publisher.id == default_publisher.id end)
      |> case do
        true -> Map.put(default_publisher, :selected, true)
        _ -> default_publisher
      end
    end)
    Map.put(db, :publishers, publishers)
  end

  def deserialize_publishers(db) do
    Map.put(db, "publishers", Enum.filter(db["publishers"], fn publisher -> publisher["selected"] == true end))
  end
end
