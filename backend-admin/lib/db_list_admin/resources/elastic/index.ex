defmodule DbListAdmin.Resource.Elastic.Index do
  use GenServer
  alias DbListAdmin.Resource.Elastic

  def init(arg) do
    initialize()
    {:ok, arg}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def initialize do
    with {:ok, _} <- creaate_index(Elastic.index_admin()),
    {:ok, _} <- creaate_index(Elastic.index_sv()),
    #{:ok, _} <- apply_index_mappings(Elastic.index_sv()),
    {:ok, _} <- creaate_index(Elastic.index_en())
   # {:ok, _} <- apply_index_mappings(Elastic.index_en())
    do
      index_all()
    else
      {:error, reason} -> IO.inspect(reason, label: "Error creating index")
      _ -> IO.inspect("Error creating index")
    end
  end

  def creaate_index(name) do
    config =  %{
      "mappings" => %{
        "properties" => %{
          "title" => %{
            "fields" => %{
              "sort" => %{
                "type" => "icu_collation_keyword",
                "language" => "sv",
                "country" => "SE"
              }
            },
            "type" => "text",
            "analyzer" => "edge_ngram_analyzer",
            "search_analyzer" => "standard"
          }
        }
      },
      "settings" => %{
        "analysis" => %{
          "analyzer" => %{
            "edge_ngram_analyzer" => %{
              "tokenizer" => "edge_ngram_tokenizer",
              "filter" => [
                "lowercase"
              ]
            }
          },
          "tokenizer" => %{
            "edge_ngram_tokenizer" => %{
              "type" => "edge_ngram",
              "min_gram" => 2,
              "max_gram" => 20,
              "token_chars" => [
                "letter",
                "digit"
              ]
            }
          }
        }
      }
    }

    Elastix.Index.delete(Elastic.elastic_url(), name)
    Elastix.Index.create(Elastic.elastic_url(), name, config)
    |> case do
      {:ok, %{body: %{"error" => reason}}} -> {:error, reason}
      {:ok, res} -> {:ok, res}
    end
  end

  def index_all do
    DbListAdmin.Resource.Database.get_databases_raw()
    |> index("sv", Elastic.index_sv())
    |> index("en", Elastic.index_en())
    |> index("admin", Elastic.index_admin())
    %{status: "All data indexed"}
    |> IO.inspect()
  end

  def index(data, lang, index) do
    data
    |> Enum.map(fn db ->
        case lang do
          "admin" -> DbListAdmin.Model.Database.remap(db)
          _ -> DbListAdmin.Model.Database.remap(db, lang)
        end
      end)
    |> Enum.map(fn db ->
      {lang, db.published}
      |> case do
        {"admin", _} -> Elastix.Document.index(Elastic.elastic_url(), index, "_doc", db.id, db, [])
        {_, true} -> Elastix.Document.index(Elastic.elastic_url(), index, "_doc", db.id, db, [])
        {_, false} -> IO.inspect("Omit index for item")
      end
    end)
    data
  end

  def apply_index_mappings(index) do
      Elastix.Mapping.put(Elastic.elastic_url(), index, "", %{
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
    })
    |> case do
      {:ok, %{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      {:ok, res} -> {:ok, res}
    end
  end
end
