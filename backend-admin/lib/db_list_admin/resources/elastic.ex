defmodule DbListAdmin.Resource.Elastic do
  def get_databases_admin(term \\ "") do
    {:ok, %{body: %{"hits" => %{"hits" => hits}}}} = Elastix.Search.search(elastic_url(), "db_en", [], base(term))
    hits
    |> Enum.map(fn db -> %{id: db["_source"]["id"], title: db["_source"]["title"]} end)
  end

  def elastic_url do
    "http://localhost:9200"
  end

  def base(term) do
    %{
      aggs: %{
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
      size: 2000,
      query: %{
        bool: %{
          must: [
            %{
                query_string: %{
                  query: term <> "*",
                  fields: ["title^15", "alternative_titles^8", "media_types.name^3", "description", "topics.name^3", "sub_topics.name^2", "publishers.name^2"]
              }
            }
          ]
        }
      }
    }
  end
end
