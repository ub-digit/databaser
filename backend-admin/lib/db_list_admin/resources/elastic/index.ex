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
    {:ok, _} <- apply_index_mappings(Elastic.index_sv()),
    {:ok, _} <- creaate_index(Elastic.index_en()),
    {:ok, _} <- apply_index_mappings(Elastic.index_en())
    do
      index_all()
    else
      {:error, reason} -> IO.inspect(reason, label: "Error creating index")
      _ -> IO.inspect("Error creating index")
    end
  end

  def creaate_index(name) do
    Elastix.Index.delete(Elastic.elastic_url(), name)
    Elastix.Index.create(Elastic.elastic_url(), name, %{})
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
      Elastix.Document.index(Elastic.elastic_url(), index, "_doc", db.id, db, [])
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
