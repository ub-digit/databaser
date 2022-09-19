defmodule DbListAdmin.Resource.Elastic do

  @admin_index "admin_index"
  def get_databases_admin(term \\ "") do
    {:ok, %{body: %{"hits" => %{"hits" => hits}}}} = Elastix.Search.search(elastic_url(), @admin_index, [], base(term))
    hits
    |> Enum.map(fn db -> %{id: db["_source"]["id"], title_en: db["_source"]["title_en"], title_sv: db["_source"]["title_sv"]} end)
  end

  def elastic_url do
    System.get_env("ELASTIC_SEARCH_URL", "http://localhost:9200")
  end

  def reindex(false), do: %{status: "use /index/reindex_admin?reindex=true to reindex"}
  def reindex(true) do
    index_all_admin()
    |> List.first()
    |> case do
      {:ok, _}  -> %{status: "Successfully reidexed admin_index"}
      {_, res}  -> %{status: res}
    end
  end

  def index_all_admin() do
    data = DbListAdmin.Resource.Database.get_databases()
    Elastix.Index.delete(elastic_url(), @admin_index)
    create_admin_index(Elastix.Index.exists?(elastic_url(), @admin_index))
    Enum.map(data, fn item ->
      IO.inspect(item, label: "ITEM IN INDEX ALL")
      Elastix.Document.index(elastic_url(), @admin_index, "_doc", item.id, item)
    end)
  end

  def create_admin_index({:ok, false}) do
    Elastix.Index.create(elastic_url(), @admin_index, %{})
  end

  def delete_from_index(id) do
    IO.inspect("DELETE FROM INDEX")
    Elastix.Document.delete(elastic_url(), @admin_index, "_doc", id)
    Elastix.Index.refresh(elastic_url(), @admin_index)
  end

  def add_to_index(data) do
    IO.inspect(data, label: "ADD TO INDEX")
    Elastix.Document.index(elastic_url(), @admin_index, "_doc", data.id, data)
    #Elastix.Index.refresh(elastic_url(), @admin_index)
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
                  fields: ["title_sv^15", "title_en^15", "alternative_titles^8", "media_types.name^3", "description", "topics.name^3", "sub_topics.name^2", "publishers.name^2"]
              }
            }
          ]
        }
      }
    }
  end
end
