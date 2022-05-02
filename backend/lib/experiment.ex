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
end