defmodule DbListAdmin.Resource.Elastic.Search do
  alias DbListAdmin.Resource.Elastic

  def get_databases_admin(params) do
    case Elastix.Search.search(Elastic.elastic_url(), Elastic.index_admin(), [], base(params)) do
      {:ok, %{body: %{"hits" => %{"hits" => hits}}}} -> remap(hits, params)
      {:ok, _} -> []
    end
  end

  def remap(hits, params) do
    bool_published(params)
    |> case do
      nil -> hits
      bool -> Enum.filter(hits, fn db ->
        (db["_source"]["published"] == bool)
      end)
    end
    |> Enum.map(fn db -> %{id: db["_source"]["id"], title_en: db["_source"]["title_en"], title_sv: db["_source"]["title_sv"]} end)
    |> Enum.sort()
  end

  def bool_published(params) do
    case params["published"] do
      "true" -> true
      true -> true
      "false" -> false
      false -> false
      _ -> nil
    end
  end


  def base(params) do
    term = params["term"] || ""
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
                  fields: ["title_sv^15", "title_en^15"]
              }
            }
          ]
        }
      }
    }
  end
end
