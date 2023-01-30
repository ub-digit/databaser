defmodule Experiment do
  def test do

  q = %{
      sort: %{"title.sort" => %{order: "desc"}},
      size: 10,
      query: %{
        bool: %{
          must: [
            %{
                query_string: %{
                  query: "dansk biografisk lexicon",
                  fields: ["title", "description", "topics.name"]
              }
            }
          ]
        }
      }
    }

    %{
    "properties" => %{
      "title" => %{
        "type" => "text",
        "fields" => %{
          "sort" => %{
            "type" => "icu_collation_keyword",
            "language" => "sv",
            "country" => "SE"
          }
        }
      }
    }
  }

  {:ok, %{body: %{"hits" => %{"hits" => res}}}} = Elastix.Search.search(elastic_url(), "db_en", [], q)
  res
  |> Enum.map(fn db -> db["_source"]["title"] end)


  end

  def elastic_url do
    System.get_env("ELASTIC_SEARCH_URL", "http://localhost:9200")
  end

  def sort(payload) do
    %{
      params: %{
        "search"                => payload["search"] || "",
        "lang"                  => payload["lang"] || "en",
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

  def agg() do
    # node_aggregations = Enum.reduce(node_aggregations, %{}, fn n, acc -> Map.put(acc, n["key"], n["doc_count"]) end)

    data = [
      %{
        id: 7,
        name: "Item 7"
      },
      %{
        id: 1,
        name: "Item 1"
      },
      %{
        id: 2,
        name: "Item 2"
      },
      %{
        id: 3,
        name: "Item 3"
      },
      %{
        id: 4,
        name: "Item 4"
      }
    ]
    #Enum.group_by(data, fn item -> item[:id] end)
    Enum.reduce(data, [], fn item, acc -> [item[:id] | acc] end)
  end

  def red do
     {:ok, "hey"}

     |> case  do
       {:ok, _} -> IO.inspect("Hey you")

     end
  end

  def sort_test() do
    [%{name: "öl"}, %{name: "sven"}, %{name: "åke"}, %{name: "ärligt"}, %{name: "roy"}, %{name: "alf"}]
    |> Enum.sort_by(fn l -> Map.get(l, :name) end)
  end

  def sort_by_property() do
    topic_id = 2
    compare = fn
      true, false -> :gt
      false, true -> :lt
      false, false -> :eq
      true, true -> :eq
    end

    sf = fn x, y ->
      x_recommended = Enum.any?(x["topics"], fn topic -> topic["is_recommended"] == true && topic["id"] == topic_id end)
      y_recommended = Enum.any?(y["topics"], fn topic -> topic["is_recommended"] == true && topic["id"] == topic_id end)
      case compare.(x_recommended, y_recommended) do
        :lt -> false
        :gt -> true
        :eq -> x["name"] < y["name"]
      end


    end
      [
      %{"name" => "ccc", "topics" => [
        %{"is_recommended" => true, "id" => 2}
      ]},
      %{"name" => "aaa", "topics" => [
        %{"is_recommended" => true, "id" => 1}
      ]},
      %{"name" => "ddd", "topics" => [
        %{"is_recommended" => false, "id" => 1}
      ]},
      %{"name" => "ccc", "topics" => [
        %{"is_recommended" => true, "id" => 1}
      ]},
      %{"name" => "bbb", "topics" => [
        %{"is_recommended" => true, "id" => 2}
      ]},
      %{"name" => "bbbb", "topics" => [
        %{"is_recommended" => false, "id" => 1}
      ]},
      %{"name" => "fffff", "topics" => [
        %{"is_recommended" => true, "id" => 2}
      ]}
  ]

  |> Enum.sort(sf)
  #|> Enum.sort_by(&{!&1["is_recommended"], &1["name"]})

  end


end
