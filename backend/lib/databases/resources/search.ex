defmodule Databases.Resource.Search do
  import Ecto.Query
  import Ecto
  @query_limit 1000
  @default_language "en"
  @index_prefix "db_"

  def index_all(data, lang) do
    index_name = get_index(lang) 
    create_index(Elastix.Index.exists?(elastic_url, index_name), index_name)
    IO.inspect(lang, label: "INDEX ALL")
    Enum.map(data, fn item -> Elastix.Document.index(elastic_url, index_name, "_doc", item.id, item) end)
  end
  
  def elastic_url do
    System.get_env("ELASTIC_SEARCH_URL", "http://localhost:9200")
  end
  
  def get_index(lang) do
    @index_prefix <> lang
  end

  def create_index({:error, _} = res, _n) do
    IO.inspect(elastic_url, label: "ERROR CREATING INDEX!")
  end

  def create_index({:ok, true}, _n), do: nil
  def create_index({:ok, false}, index_name) do
    Elastix.Index.create(elastic_url, index_name, %{})
  end
  def show(%{"id" => id} = payload) do
    IO.inspect(payload, label: "payload in show")
    search_index(payload)
    |> List.first
  end

  def popular_databases(lang \\ @default_language) do
    IO.inspect(lang, label: "lang in is poopular")
    search_index(%{"is_popular" => true, "lang" => lang})
  end

  def base(term \\ "*") do
    %{
      size: @query_limit,
      query: %{
        bool: %{
          must: [
            %{
                query_string: %{
                  query: term <> "*",
                  fields: ["title", "description", "topics.name"]
              } 
            } 
          ]
        }
      }
    }
  end

  def get_total_documents() do
    Elastix.Search.count(elastic_url, get_index(@default_language), ["_doc"], %{})
    |> elem(1)
    |> Map.get(:body)
    |> Map.get("count")
  end
  
  def search_index(payload \\ %{})  do
    %{params: params, filter: filter} = remap_payload(payload)
    lang = params["lang"]
    filter = build_filter(filter)
    q = base(params["search"])
    q = add_filter(filter, q)
    #IO.inspect(q, label: "QUERY")
    Elastix.Search.search(elastic_url, get_index(lang), ["_doc"], q)
    |> elem(1)
    |> Map.get(:body)
    |> get_in(["hits", "hits"])
    |> Enum.map(fn item -> Map.get(item, "_source") end)
    |> sort_result(params["sort_order"]) # Move to elastic query? 
  end

  def search(payload \\ %{}) do
    payload
    |> search_index
    |> mark_recommended_databases(payload)
    |> shift_recommended_to_top
    |> remap(payload)
  end

  def shift_recommended_to_top(databases) do
    recommended_databases = Enum.filter(databases, fn db -> Map.get(db, "is_recommended") == true end)
    IO.inspect(is_list(recommended_databases), label: "hey hey")
    #db_ids = Enum.map(recommended_databases, fn db -> Map.get(db, "id") end)
    databases = Enum.filter(databases, fn db -> Map.get(db, "is_recommended") == false end)
    |> List.flatten
    databases = [recommended_databases | databases]
    |> List.flatten
  end

  def mark_recommended_databases(databases, %{"topic" => topic} = payload) do
    databases
    |> Enum.map(fn db -> Map.put(db, "is_recommended", Enum.member?(db["recommended_in_topics"], topic)) end)
    |> mark_recommended_databases_sub_topics(payload)
  end
  
  def mark_recommended_databases(databases, payload), do: databases

  def mark_recommended_databases_sub_topics(%{"is_recommended" => false} = databases, %{"sub_topics" => sub_topics} = payload) do
    databases
    |> Enum.map(fn db -> Map.put(db, "is_recommended", Enum.member?(db["recommended_in_sub_topics"], sub_topics)) end)
  end

  def mark_recommended_databases_sub_topics(databases, payload), do: databases


  def sort_result(dbs, "asc") do
    dbs
    |> Enum.sort_by(fn db -> db["title"] end)
  end

  def sort_result(dbs, "desc") do
    dbs
    |> Enum.sort_by(fn db -> db["title"] end)
    |> Enum.reverse
  end

  def remap_payload(%{} = payload) do
    %{
      params: %{
        "search"                => payload["search"] || "",
        "lang"                  => payload["lang"] || @default_language,
        "sort_order"            => payload["sort_order"] || "asc"
      },
      filter: %{
        "id"                    => payload["id"],
        "topics.id"             => payload["topic"],
        "topics.sub_topics.id"  => payload["sub_topics"] || [],
        "media_types.id"         => payload["mediatype"],
        "public_access"         => payload["show_free"] || nil,
        "is_popular"            => payload["is_popular"]
      }
    }
  end

  
  def remap(databases, payload) do
    %{
      _meta: %{total: get_total_documents(), found: length(databases)},
      data: databases,
      filters:
      %{
        mediatypes: get_media_types(databases),
        topics: get_topics(payload)
      }
    }
  end
  
  def get_topics(payload) do
    sub_topics_param = Map.get(payload, "sub_topics", [])
    topic = Map.get(payload, "topic")
    IO.inspect(topic, label: "topic in get_topics")
    payload = Map.delete(payload, "sub_topics")
    payload
    |> remap_payload
    topics = load_topics(payload, topic, sub_topics_param)
  end
  
  def load_topics(payload, nil, []) do
    sort_topics(search_index(payload))
  end
  
  def mark_sub_topics(item) do
    sub_topics = Map.get(item, "sub_topics")
    |> Enum.uniq
    |> Enum.map(fn st -> Map.put(st, "selected", false) end)
    Map.put(item, "sub_topics", sub_topics)
  end

  def load_topics(payload, topic, sub_topics) do
    topics = sort_topics(search_index(payload), topic)
    |> List.first
    st = Map.get(topics, "sub_topics")
    |> Enum.map(fn item -> mark_selected(item, sub_topics) end)
    |> Enum.uniq
    [Map.put(topics, "sub_topics", st)]
  end
  
  def mark_selected(item, st_list) do
    item
    |> Map.put("selected", Enum.member?(st_list, Map.get(item, "id")))
  end
  
  def sort_topics(databases) do
    topics = databases
    |> Enum.map(fn item -> Map.get(item, "topics") end)
    |> List.flatten
    |> Enum.map(fn item -> Map.delete(item, "sub_topics") end)
    |> Enum.uniq
  end

  def sort_topics(databases, filter_topic) do
    #generate list of topics in search result
    topics = databases
    |> Enum.map(fn db -> db["topics"] end)
    |> List.flatten
    |> Enum.filter(fn item -> item["id"] == filter_topic end)
    
    sub_topics = topics
    |> Enum.map(fn topic -> Map.get(topic, "sub_topics") end)
    |> List.flatten
    |> Enum.uniq
    topics
    |> Enum.map(fn item -> Map.delete(item, "sub_topics") end)
    |> Enum.uniq
    |> Enum.map(fn item -> Map.put(item, "sub_topics", sub_topics) end)
  end
  
  def get_media_types(databases) do
    databases
    |> Enum.map(fn db -> db["media_types"] end)
    |> List.flatten
    |> Enum.uniq
  end

  def has_filter([]), do: nil
  def has_filter(list), do: list    
  
  def add_filter(nil, q), do: q 
  def add_filter([], q), do: q 

  def add_filter(filter, q) do
    bool = q.query.bool
    bool = Map.put(bool, :filter, filter)
    put_in(q, [:query, :bool], bool)
  end
  
  def build_filter(filter) do
    filter
    # clear filter of nil values and empty lists
    |> Enum.filter(fn ({_, v}) -> !is_nil(v) || (is_list(v) &&  Enum.count(v) < 1) end)
    |> Map.new
    |> Enum.map(fn ({k, v}) -> format_filter_item({k, v}) end)
    |> List.flatten
    |> has_filter
  end

  # when filter item is a list, split list into seperate items
  def format_filter_item({k, v} = item) when is_list(v) do
    %{
      bool: %{
        should: List.flatten(Enum.map(v, fn val -> %{match: %{k => val}} end))
      }
    }
  end

  def format_filter_item({k, v} = item) do
    %{match: %{k => v}}
  end

  def  mark(dbs, tp) do 
    dbs
    |> Enum.map(fn (db) -> IO.inspect(db) end)
  end

  
end

