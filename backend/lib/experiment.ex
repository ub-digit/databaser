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

  #{:ok, %{status_code: 200}} = Elastix.Mapping.put(elastic_url, "db_en", nil, m)
  {:ok, %{body: %{"hits" => %{"hits" => res}}}} = Elastix.Search.search(elastic_url, "db_en", [], q)
  res
  |> Enum.map(fn db -> db["_source"]["title"] end)
  
  
  end

  def elastic_url do
    System.get_env("ELASTIC_SEARCH_URL", "http://localhost:9200")
  end
end