defmodule DbListAdmin.Resource.Elastic.Search do
  alias DbListAdmin.Resource.Elastic

  def get_databases_admin(params) do
    q = base(params)
    |>  put_in([:query, :bool, :filter], build_filter(params))
    |> IO.inspect(label: "q")
    case Elastix.Search.search(Elastic.elastic_url(), Elastic.index_admin(), [], q) do
      {:ok, %{body: %{"hits" => %{"hits" => hits}}}} -> remap(hits)
      {:ok, _} -> []
    end
  end

  def build_filter(params) do
    params
    |> Map.filter(fn {key, _} -> is_valid_filter_key(key) end)
    |> Enum.map(fn {key, val} ->
      %{match: %{}}
      |> put_in([:match, key], val)
    end)
  end

  def is_valid_filter_key(key) do
    # Fill this list with valid filter keys ("is_new", "is_trial" etc.)
    Enum.member?(
      [
        "published",
        "is_trial",
        "is_new",
        "is_popular"
      ],
      key
      )
  end

  def remap(hits) do
    hits
    |> Enum.map(fn db -> %{id: db["_source"]["id"], title_en: db["_source"]["title_en"], title_sv: db["_source"]["title_sv"]} end)
    |> Enum.sort()
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
                  default_operator: "AND",
                  fields: ["title_sv^15", "title_en^15"]
              }
            }
          ],
          filter: []
        }
      }
    }
  end
end
