defmodule Databases.Resource.Search do
  @query_limit 2000
  @default_language "en"
  @index_prefix "databases_"


  def elastic_url do
    System.get_env("ELASTIC_SEARCH_URL", "http://localhost:9200")
  end

  def get_index(lang) do
    @index_prefix <> lang
  end

  def show(%{"id" => _id} = payload) do
    {databases, _} = search_index(payload)
    databases
    |> List.first
  end

  def popular_databases(lang \\ @default_language) do
    search_index(%{"is_popular" => true, "lang" => lang})
  end

  def base(term) do
    %{
      aggs: %{
        freely_available: %{
          terms: %{
            field: "public_access"
          }
        },
        topics: %{
          terms: %{
            field: "topics.id",
            size: 1000
          }
        },
        sub_topics: %{
          terms: %{
            field: "topics.sub_topics.id",
            size: 1000
          }
        },
        media_types: %{
          terms: %{
            field: "media_types.id",
            size: 1000
          }

        }

      },
      size: @query_limit,
      query: %{
        bool: %{
          must: [
            %{
                query_string: %{
                  query: term <> "*",
                  default_operator: "AND",
                  fields: ["title^15", "alternative_titles.title^8", "media_types.name^3", "description", "topics.name^3", "sub_topics.name^2", "publishers.name^2"]
              }
            }
          ]
        }
      }
    }
  end

  def get_total_documents() do
    {:ok, %{body: %{"count" => count}}} = Elastix.Search.count(elastic_url(), get_index(@default_language), [], %{})
    count
  end

  def search_index(payload \\ %{})  do
    %{params: params, filter: filter} = remap_payload(payload)
    lang = params["lang"]
    filter = build_filter(filter)
    q = base(params["search"])
    q = add_filter(filter, q)
    |> add_sort_order(params["sort_order"])
    {:ok, %{body: %{"aggregations" => aggregations, "hits" => %{"hits" => hits}}}} = Elastix.Search.search(elastic_url(), get_index(lang), [], q)
    databases = hits
    |> Enum.map(fn item -> Map.get(item, "_source") end)
    {databases, aggregations}
  end

  def add_sort_order(q, ""), do: Map.put(q, :sort, %{"title.sort" => %{order: "asc"}})
  def add_sort_order(q, _), do: q

  def search(payload \\ %{}) do
    payload
    |> search_index
    |> shift_recommended_databases_to_top(payload)
    |> remap(payload)
  end



  #No sub topics in filter
  def shift_recommended_databases_to_top({databases, aggregations}, %{"topic" => topic, "sub_topics" => []}) do
    recommended_databeses =
      Enum.filter(databases, fn db ->
        Enum.any?(db["topics"], fn db_topic ->
          db_topic["id"] == topic && db_topic["recommended"]
        end)
      end)
      |> Enum.map(fn db -> Map.put(db, "is_recommended", true) end)

      rest = Enum.filter(databases, fn db ->
        Enum.member?(recommended_databeses, db) != true
      end)
      databases = [recommended_databeses | rest]
      |> List.flatten()

      {databases, aggregations}
    end

    def shift_recommended_databases_to_top({databases, aggregations}, %{"topic" => _, "sub_topics" => sub_topics}) when length(sub_topics) > 0 do
      recommended_databases  =
      Enum.filter(databases, fn db ->
        topics = db["topics"]
        Enum.map(topics, fn topic ->
           db_sub_topics = topic["sub_topics"]
           Enum.map(db_sub_topics, fn db_sub_topic ->
            Enum.member?(sub_topics, db_sub_topic["id"]) && db_sub_topic["recommended"]
          end)
        end)
         |> List.first()
         |> Enum.member?(true)
      end)
      |> Enum.map(fn db -> Map.put(db, "is_recommended", true) end)

      rest = Enum.reject(databases, fn db ->
        Enum.any?(recommended_databases, fn r_db ->
          (r_db["id"] == db["id"])
        end)
      end)
      databases = [recommended_databases | rest]
      |> List.flatten()

      {databases, aggregations}
    end

    def shift_recommended_databases_to_top({databases, aggregations}, %{}) do
      {databases, aggregations}
    end

  def remap_payload(%{} = payload) do
    %{
      params: %{
        "search"                => String.trim(payload["search"] || ""),
        "lang"                  => payload["lang"] || @default_language,
        "sort_order"            => payload["sort_order"] || "asc",
        "topic"                 => payload["topic"] || nil,
        "sub_topics"            => payload["sub_topics"] || []
      },
      filter: %{
        "id"                    => payload["id"],
        "topics.id"             => payload["topic"] || nil,
        "topics.sub_topics.id"  => payload["sub_topics"] || [],
        "media_types.id"        => payload["mediatype"],
        "public_access"         => payload["show_free"] || nil,
        "is_popular"            => payload["is_popular"],
        "published"             => payload["published"]
      }
    }
  end

  def remap({databases, aggregations}, payload) do
    %{
      _meta: %{total: get_total_documents(), found: length(databases)},
      data: databases,
      filters:
      %{
        show_freely_available: freely_available(aggregations),
        mediatypes: get_media_types(databases, aggregations),
        topics: get_topics(payload)
      }
    }
  end

  def freely_available(%{"freely_available" => %{"buckets" => buckets}}) when is_list(buckets) do
    buckets
    |> Enum.any?(fn bucket -> Map.get(bucket, "key_as_string") == "true" end)
  end

  def freely_available(%{"freely_available" => %{"buckets" => buckets}}) when length(buckets) == 0, do: false

  def get_topics(payload) do
    sub_topics_param = Map.get(payload, "sub_topics", [])
    topic = Map.get(payload, "topic")
    Map.delete(payload, "sub_topics")
    #|> remap_payload
    |> load_topics(topic, sub_topics_param)
  end

  def add_aggregations(node, node_aggregations) do
    node_aggregations = Enum.reduce(node_aggregations, %{}, fn n, acc -> Map.put(acc, n["key"], n["doc_count"]) end)
    node
    |> Enum.map(fn item -> Map.put(item, "count", node_aggregations[item["id"]]) end)
  end

  def mark_sub_topics(item) do
    sub_topics = Map.get(item, "sub_topics")
    |> Enum.uniq
    |> Enum.map(fn st -> Map.put(st, "selected", false) end)
    Map.put(item, "sub_topics", sub_topics)
  end

  def load_topics(payload, nil, []) do
    {databases, aggregations} = search_index(payload)
    %{"topics" => %{"buckets" => topics_agg}} = aggregations
    sort_topics(databases)
    |> add_aggregations(topics_agg)
  end

  def load_topics(payload, topic, sub_topics) do
    {databases, aggregations} = search_index(payload)
    %{"sub_topics" => %{"buckets" => sub_topics_agg}} = aggregations
    topics = sort_topics(databases, topic)
    |> List.first
    st = Map.get(topics, "sub_topics", [])
    |> Enum.map(fn sub -> Map.delete(sub, "recommended") end)
    |> Enum.uniq()
    |> add_aggregations(sub_topics_agg)
    |> Enum.map(fn item -> mark_selected(item, sub_topics) end)
    |> Enum.uniq
    [Map.put(topics, "sub_topics", st)]
  end

  def mark_selected(item, st_list) do
    item
    |> Map.put("selected", Enum.member?(st_list, Map.get(item, "id")))
  end

  def sort_topics(databases) do
    databases
    |> Enum.map(fn item -> Map.get(item, "topics") end)
    |> List.flatten
    |> Enum.map(fn item -> Map.delete(item, "sub_topics") end)
    |> Enum.map(fn item -> Map.delete(item, "recommended") end)
    |> Enum.uniq
    |> Enum.sort_by(fn topic -> Map.get(topic, "name") end)
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
    |> Enum.sort_by(fn sub_topic -> Map.get(sub_topic, "name") end)

    topics
    |> Enum.map(fn item -> Map.delete(item, "sub_topics") end)
    |> Enum.uniq
    |> Enum.map(fn item -> Map.put(item, "sub_topics", sub_topics) end)
    |> Enum.sort_by(fn topic -> Map.get(topic, "name") end)
  end

  def get_media_types(databases, aggregations) do
    %{"media_types" => %{"buckets" => media_types_agg}} = aggregations
    databases
    |> Enum.map(fn db -> db["media_types"] end)
    |> List.flatten
    |> Enum.uniq
    |> add_aggregations(media_types_agg)
    |> Enum.sort_by(fn media_type -> Map.get(media_type , "name") end)

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
  def format_filter_item({k, v}) when is_list(v) do
    %{
      bool: %{
        should: List.flatten(Enum.map(v, fn val -> %{match: %{k => val}} end))
      }
    }
  end

  def format_filter_item({k, v}) do
    %{match: %{k => v}}
  end


end
