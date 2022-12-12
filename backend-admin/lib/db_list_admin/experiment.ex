defmodule Experiment do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query

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

  def ttt(m) when Map.has_key?(m, "tjoff") == false do
    "SSDADSDS"
  end
end
