defmodule DbListAdmin.Resource.Elastic.Index do
  alias DbListAdmin.Resource.Elastic

  def initialize do
    data = DbListAdmin.Resource.Database.get_databases_raw()

    with {:ok, _} <- create_index(Elastic.index_admin()),
    {:ok, _} <- create_index(Elastic.index_sv()),
    {:ok, _} <- create_index(Elastic.index_en())
    do
      index_all(data)
    else
      {:error, reason} -> IO.inspect(reason, label: "Error creating index")
      _ -> IO.inspect("Error creating index")
    end
  end

  def config do
    %{
      "settings" => %{
        "analysis" => %{
          "filter" => %{
            "autocomplete_filter" => %{
              "type" => "edge_ngram",
              "min_gram" => 1,
              "max_gram" => 20,
              "token_chars" => [
                "letter",
                "digit",
                "custom"
              ],
              "custom_token_chars" => [
                "å",
                "ä",
                "ö",
                "Å",
                "Ä",
                "Ö",
                "-"
              ]
            }
          },
          "analyzer" => %{
            "autocomplete" => %{
              "type" => "custom",
              "tokenizer" => "standard",
              "filter" => [
                "lowercase",
                "autocomplete_filter"
              ]
            }
          }
        }
      },
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
            "analyzer" => "autocomplete",
            "search_analyzer" => "standard"
          },
          "id" => %{
            "type" => "keyword"
          }
        }
      }
    }
  end

  def create_index(name) do
    # config =  %{
    #   "mappings" => %{
    #     "properties" => %{
    #       "title" => %{
    #         "fields" => %{
    #           "sort" => %{
    #             "type" => "icu_collation_keyword",
    #             "language" => "sv",
    #             "country" => "SE"
    #           }
    #         },
    #         "type" => "text",
    #         "analyzer" => "edge_ngram_analyzer",
    #         "search_analyzer" => "standard"
    #       }
    #     }
    #   },
    #   "settings" => %{
    #     "analysis" => %{
    #       "analyzer" => %{
    #         "edge_ngram_analyzer" => %{
    #           "tokenizer" => "edge_ngram_tokenizer",
    #           "filter" => [
    #             "lowercase"
    #           ]
    #         }
    #       },
    #       "tokenizer" => %{
    #         "edge_ngram_tokenizer" => %{
    #           "type" => "edge_ngram",
    #           "min_gram" => 2,
    #           "max_gram" => 20,
    #           "token_chars" => [
    #             "letter",
    #             "digit"
    #           ]
    #         }
    #       }
    #     }
    #   }
    # }

    Elastix.Index.delete(Elastic.elastic_url(), name)
    Elastix.Index.create(Elastic.elastic_url(), name, config())
    |> case do
      {:ok, %{body: %{"error" => reason}}} -> {:error, reason}
      {:ok, res} -> {:ok, res}
    end
  end

  def index_all(data) do
    start_time = System.monotonic_time(:millisecond)
    data
    |> index("sv", Elastic.index_sv())
    |> index("en", Elastic.index_en())
    |> index("admin", Elastic.index_admin())
  end_time = System.monotonic_time(:millisecond)
  IO.inspect("Indexing took #{end_time - start_time} ms")
    %{status: "ok", message: "databases successfully indexed"}
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
end
