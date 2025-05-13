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
    |> sort_terms_of_use()
  end

  def sort_terms_of_use(db) do
    default_terms_of_use = Databases.Model.TermsOfUse.get_default_terms_of_use()
    terms_of_use = db["terms_of_use"]
    |> Enum.map(fn item ->
      db_terms_of_use = Enum.find(default_terms_of_use, fn default_item ->
        default_item.code == item["code"]
      end)
      Map.put(item, :order, db_terms_of_use.order)
    end)
    ordered = Enum.sort_by(terms_of_use, fn item -> Map.get(item, :order) end)
    Map.put(db, "terms_of_use", ordered)
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
          must: get_query_type(term)
        }
      }
    }
  end

  def get_query_type("") do
    [
      %{
        match_all: %{}
      }
    ]
  end

  def get_query_type(term) do
    %{
      query_string: %{
        default_operator: "AND",
        fields: get_search_fields(),
        query: term
      }
    }
  end

  def get_search_fields() do
    System.get_env("DEFAULT_SEARCH_FIELDS", "title^15;alternative_titles.title^8;media_types.name^3;media_types.alternative_names^3;description;topics.name^3;topics.alternative_names^3;sub_topics.name^2;sub_topics.alternative_names^2;publishers.name^2;recommended^50")
    |> String.split(";")
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
    # |> IO.inspect(label: "Q")
    |> add_sort_order(params["sort_order"], params["search"])
    {:ok, %{body: %{"aggregations" => aggregations, "hits" => %{"hits" => hits}}}} = Elastix.Search.search(elastic_url(), get_index(lang), [], q)
    databases = hits

    |> Enum.map(fn item ->
      Map.get(item, "_source")
      |> Map.put("score" , Map.get(item, "_score"))
    end)
    {databases, aggregations}
  end

  def add_sort_order(q, "", ""), do: Map.put(q, :sort, %{"title.sort" => "asc"})
  def add_sort_order(q, "", _term), do: q
  def add_sort_order(q, order, _term), do: Map.put(q, :sort, %{"title.sort" => order})

  def search(payload) do

    has_faulty_characters(payload)
    |> case do
      true -> %{
        data: [],
        _meta: %{
          total: 0,
          found: 0
        },
        filters: %{
          show_freely_available: false,
          mediatypes: [],
          topics: []
        }
      }
      false -> search(payload, :proceed)
    end
  end

  def search(payload, :empty) do
    Map.put(payload, "search", "")
    search(payload, :proceed)
    |> Map.put("data", [])
  end

  def search(payload, :proceed) do
    payload = payload |> set_defaults_payload()
    payload
    |> search_index
    |> shift_recommended_databases_to_top(payload)
    |> remap(payload)
  end



  def set_defaults_payload(%{} = payload) do
    payload
    |> Map.put("search", String.trim(payload["search"] || ""))
    |> Map.put("lang", payload["lang"] || @default_language)
    |> Map.put("sort_order", payload["sort_order"] || "")
    |> Map.put("topic", payload["topic"] || nil)
    |> Map.put("sub_topics", payload["sub_topics"] || [])
  end


  def has_faulty_characters(payload) do
    str = Map.get(payload, "search", "")
    cahrs = ["]", "[", "{", "}", "(", ")", "*", "?", "+", "^", "$", "|", "\\", "/", "!", "?"]
    Enum.any?(cahrs, fn char -> String.contains?(str, char) end)
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

      rest = Enum.reject(databases, fn db -> Enum.any?(recommended_databeses, fn r_db -> (r_db["id"] == db["id"]) end) end)
      databases = [recommended_databeses | rest]
      |> List.flatten()

      {databases, aggregations}
    end

    def shift_recommended_databases_to_top({databases, aggregations}, %{"topic" => _, "sub_topics" => sub_topics}) when length(sub_topics) > 0 do
      IO.inspect(sub_topics, label: "Sub topics in filter")
      recommended_databases  =
      Enum.filter(databases, fn db ->
        topics = db["topics"]
        Enum.map(topics, fn topic ->
           db_sub_topics = topic["sub_topics"]
           Enum.map(db_sub_topics, fn db_sub_topic ->
            Enum.member?(sub_topics, db_sub_topic["id"]) && db_sub_topic["recommended"]
          end)
        end)
         |> List.flatten()
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
        "sort_order"            => payload["sort_order"] || "",
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
    |> case do
      nil -> %{}
      tp -> tp
    end
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
