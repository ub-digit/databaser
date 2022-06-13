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

    m = %{
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

  {:ok, %{body: %{"hits" => %{"hits" => res}}}} = Elastix.Search.search(elastic_url, "db_en", [], q)
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
end
