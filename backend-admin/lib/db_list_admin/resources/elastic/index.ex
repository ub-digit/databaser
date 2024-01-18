defmodule DbListAdmin.Resource.Elastic.Index do
  alias DbListAdmin.Resource.Elastic

  def initialize do

    data = DbListAdmin.Resource.Database.get_databases_raw()
    with {:ok, _} <- create_index(Elastic.index_admin()),
         {:ok, _} <- create_index(Elastic.index_sv()),
         {:ok, _} <- create_index(Elastic.index_en()) do
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
              "min_gram" => 2,
              "max_gram" => 10,
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
          "alternative_titles.title" => %{
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
          "topics.name" => %{
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
          "sub_topics.name" => %{
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
          "recommended" => %{
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
          "publishers.name" => %{
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
          "media_types.name" => %{
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


  def remap_one_database_for_index(db, index) do
    [
      %{"index" =>  %{"_index" => index, "_id" => db.id}},
      db
    ]
    |> List.flatten()
  end

  def index(data, lang, index) do

    index_data = data
    |> filter_published(lang)
    |> Enum.map(fn db ->
      case lang do
        "admin" -> DbListAdmin.Model.Database.remap(db)
        _ -> DbListAdmin.Model.Database.remap(db, lang)
      end
    end)
    |> Enum.map(fn db -> remap_one_database_for_index(db, index) end)
    |> List.flatten()
    Elastix.Bulk.post(Elastic.elastic_url(), index_data)
    data
  end

  def filter_published(data, "admin"), do: data
  def filter_published(data, _) do
    Enum.filter(data, fn db -> db.published end)
  end

end
