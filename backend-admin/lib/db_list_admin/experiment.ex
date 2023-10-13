defmodule Experiment do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query
  @bulk_index "bulkindex"
  @url "http://localhost:9200"

  def test() do
    delete_data = %{
      "id" => 1006,
      "name_sv" => "TEST TOPIC (sv)",
      "name_en" => "TEST TOPIC (en)",
      "sub_topics" => [
        %{"name_sv" => "sub topic 1 sv", "name_en" => "sub topic 1 en", "id" => 1001, "delete" => true},
        %{"name_sv" => "sub topic 2 sv", "name_en" => "sub topic 2 en", "id" => 1002, "delete" => true},
        %{"name_sv" => "sub topic 3 sv", "name_en" => "sub topic 3 en", "id" => 1003, "delete" => true}
      ]
    }
    DbListAdmin.Resource.Topic.Create.create_or_update(delete_data)
  end

  def check_delete() do
    topics = DbListAdmin.Resource.Topic.get_topics()
    connections = (from database_topics in Model.DatabaseTopic,
    preload: [:topic])
    |> Repo.all()
    |> Enum.map(fn item -> Map.get(Map.get(item, :topic), :id) end)
    |> Enum.uniq()

    topics
    |> Enum.map(fn topic ->
      Map.put(topic, :can_be_deleted, Enum.member?(connections, topic[:id]) == false)
    end)
  end

  def topics_base do
    from topics in Model.Topic,
    left_join: db_topics in Model.DatabaseTopic,
    on: topics.id == db_topics.topic_id,
    left_join: sub_topics in Model.SubTopic,
    on: topics.id == sub_topics.topic_id,
    preload: [:database_topics, :sub_topics]
  end

  def pre do
    (from db in Model.Database,
    join: db_topics in assoc(db, :database_topics),
    join: topics in assoc(db_topics, :topic),
    where: db.id == 32,
    preload: [database_topics: {db_topics, topic: topics}])
    |> Repo.all()
  end

  def base do
    (from t in topics_base())
    |> Repo.all()
    #|> Enum.map(fn item -> Model.Topic.remap(item) end)
  end

  def create_media_type do
    data = %{
      #"id" => 391,
      "name_en" => "test media type sv",
      "name_sv" => "test media type en"
      }
      DbListAdmin.Resource.MediaType.create_or_update(data)
  end

  def create_pub do
    data = %{
      "name" => "Fine Publisher"
    }
    DbListAdmin.Resource.Publisher.create_or_update(data)
  end

  def delete_puiblisher(id) do
    DbListAdmin.Resource.Publisher.delete(id)
  end

  def get_titles() do
    Repo.all(Model.DatabaseAlternativeTitle)
    |> Enum.map(fn item -> Model.DatabaseAlternativeTitle.remap(item) end)
  end

  def delete_all_urls_with_database_id(id) do
    (from url in Model.DatabaseUrl,
    where: url.database_id == ^id)
    |> Repo.delete_all()
  end


  def mark_topics do
    topics = [
      %{id: 1,
      sub_topics:
      [
        %{id: 10}, %{id: 11}
      ]},
      %{id: 2,
      sub_topics:
      [
        %{id: 20}, %{id: 21}
      ]}
    ]

    db_topics = [
      %{id: 1,
      sub_topics:
      [
        %{id: 10}
      ]}
    ]


    topics
    |> Enum.map(fn topic ->
      Enum.map(db_topics, fn db_topic ->
        case topic.id == db_topic.id do
          true -> Map.put(topic, :selected, true) |> mark_sub_topics(db_topic)
          _ -> topic
        end
      end)
      |> List.first()
    end)
  end

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

  def h do
    [1, 2, 3, 4]
    |> List.first()
  end


  def search(term) do
    q =
      %{
        query: %{
          query_string: %{
            query: term,
            fields: ["title_en"]
          }
        }
      }
      {:ok, %{body: %{"hits" => %{"hits" => hits}}}} = Elastix.Search.search("http://localhost:9200", "admin_index", [], q)
      hits
  end

  def test_with(json) do
    with {:ok, val} <- hey(json)

    do
      %{status: "All ok", val: val}
    else
      nil -> %{error: %{}}
      error -> error
    end
  end


  def hey(%{id: _} = json) do
    {:ok, json}
  end

  def hey(%{} = json) do
    {:error, json}
  end

  def test_index do
    data = DbListAdmin.Resource.Database.get_databases_raw()
    |> Enum.map(fn db -> Model.Database.remap(db, "sv") end)
    |> Enum.map(fn db -> [%{index: %{_id: db.id}}, db] end)
    |> List.flatten()
    |> IO.inspect(label: "Index list")
    Elastix.Bulk.post("http://localhost:9200", data, index: "test", type: "_doc")
  end

  # Elastix.Bulk.post("http://localhost:9200", [%{index: %{_id: "1"}}, %{user: "kimchy"}], index: "twitter", type: "tweet")
  def start do
    IO.inspect("HEY I'M STARTING")
  end

  def test_db do
    DbListAdmin.Resource.Database.get_databases_raw()

    |> Enum.map(fn item -> DbListAdmin.Model.Database.remap(item, "sv") end)
  end


  def test_merge do
    #tou = %{code: "hey", permitted: false, description_en: "en description", description_sv: "Description sv"}
    tou = nil
    tou_default = %{code: "hey", permitted: "N/A", description_en: "", description_sv: ""}
    Map.merge(tou_default, tou, &fix_conflicts/3)
  end



  def fix_conflicts(key, v1, v2) when key == :permitted do
    "hola bandola"
  end

  def fix_conflicts(_, v1, _) do
    v1
  end

  def (a) ||| (b) do
    Map.merge(a, b)
  end

  def short_merge do
    %{name: "Lars"} ||| %{age: 30}
  end

  def a --- b do
    Map.merge(a, b)
  end

  def performance(f, tag \\ "Performance time") do
    start_time = System.monotonic_time(:millisecond)
    res = f.()
    end_time = System.monotonic_time(:millisecond)
    IO.inspect("#{tag} #{(end_time - start_time)} ms")
    res
  end

  def base_query do
    from (db in Model.Database)
  end

  def load_databases() do

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
    |> Repo.all()
  end

  def ttt do
    performance(&load_databases/0, "Loading database")
  end

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


  def bulk_index() do
    # index = "test_bulk"
    # data = load_databases()
    # case Elastix.Index.exists?("http://localahost:9200", index) do
    #   {:ok, true} -> Elastix.Index.delete("http://localhost:9200", index)
    #   _ -> Elastix.Index.create("http://localhost:9200", index, %{})
    # end
    # data = data
    # |> Enum.take(5)

    # # |> Enum.map(fn db -> Model.Database.remap(db, "sv") end)
    # # |> Enum.map(fn db -> [%{index: %{_id: db.id}}, db] end)
    # # |> List.flatten()
    # # Elastix.Bulk.post("http://localhost:9200", data, index: "test_bulk", type: "_doc")
    # # |> Jason.encode!()
    # |> remap_for_index()
    # |> IO.inspect()

    # IO.inspect(label: "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssRemap")
    # Elastix.Bulk.post("http://localhost:9200", data, index: index, type: "_doc")

    Elastix.Index.delete(@url, @bulk_index)
    Elastix.Index.create(@url, @bulk_index, DbListAdmin.Resource.Elastic.Index.config)
    data = Experiment.load_databases()
    #|> Enum.take(2) # remove later
    |> Enum.map(fn db -> Model.Database.remap(db, "sv") end)
    # |> Enum.map(fn db ->
    #   %{
    #     id: db.id,
    #     title: db.title,
    #     alternative_titles: db.alternative_titles

    #   }
    # end)
    |> Enum.map(&remap_one_database_for_index/1)
    |> List.flatten()
    |> IO.inspect(label: "Remapped")

    Elastix.Bulk.post(@url, data)



  end

  def remap_one_database_for_index(db) do

    [
      %{"index" =>  %{"_index" => @bulk_index, "_id" => db.id}},
      db
    ]
    |> List.flatten()
    |> IO.inspect(label: "Remapped one database")

  end

  def bbulk do
    Elastix.Index.delete(@url, @bulk_index)
    Elastix.Index.create(@url, @bulk_index, %{})
    Elastix.Bulk.post(@url,
    # [
    #   %{"index" => %{"_id" => "99991", "_index" => "bulkindex"}},
    #   %{"id" => "99991"},
    #   %{"index" => %{"_id" => "99991", "_index" => "bulkindex"}},
    #   %{"title" => "21st Century Sociology (sv)"},
    #   %{"index" => %{"_id" => "99992", "_index" => "bulkindex"}},
    #   %{"id" => "99992"},
    #   %{"index" => %{"_id" => "99992", "_index" => "bulkindex"}},
    #   %{"title" => "AATA online (sv)"}
    # ]
    [
      %{"index" =>  %{"_index" => @bulk_index, "_id" => "1001"}},
      %{"user" => "bob", "stek" => "fjong"},
      %{"index" =>  %{"_index" => @bulk_index, "_id" => "1002"}},
      %{"user" => "bob", "stek" => "fjong"}
    ]
    )

  end

  def ggg(yes) do

    case yes do
      true ->
          IO.inspect("Hello yes is true")
      false ->

          IO.inspect("Hello yes is false")
    end

  end


end
