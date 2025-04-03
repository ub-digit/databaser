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
      malfunction_message_en: "",
      malfunction_message_sv: "",
      malfunction_message_active: false,
      topics: [],
      media_types: [],
      publishers: [],
      terms_of_use: [],
      urls: [],
      published: false,
      is_trial: false,
      is_new: false,
      direct_link_is_hidden: false
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
    |> Enum.filter(fn item -> item["permitted"] != "N/A" end)
    |> Enum.map(fn item ->
      case item["permitted"] do
        "yes" -> Map.put(item, "permitted", true)
        "no" -> Map.put(item, "permitted", false)
        nil -> Map.put(item, "permitted", nil)
        _ -> item
      end

    end)
    Map.put(db, "terms_of_use", tou)
  end

  def serialize_terms_of_use(db) do
    tous = db.terms_of_use
    default_tous = Model.TermsOfUse.get_default_terms_of_use()
    |> Enum.map(fn default_tou ->
      tou = Enum.find(tous, fn t -> t.code == default_tou.code end)
      merge_tou(default_tou, tou)
    end)
    Map.put(db, :terms_of_use, default_tous)
  end


  def merge_tou(default_tou, tou) when is_nil(tou), do: default_tou
  def merge_tou(default_tou, tou) do
    Map.merge(default_tou, tou, &tou_merge_rules/3)
  end

  def tou_merge_rules(key, _, val2) when key == :permitted do
    convert = fn
      true -> "yes"
      false -> "no"
      nil -> nil
    end
    convert.(val2)
  end

  def tou_merge_rules(_,_ , val2), do: val2

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

  def set_public_access(%{"access_information_code" => "freely_available"} = db) do
    Map.put(db, "public_access", true)
  end

  def set_public_access(db) do
    Map.put(db, "public_access", false)
  end
end
