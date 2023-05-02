defmodule DbListAdmin.Resource.Elastic.Clone do
  import Elastix.HTTP, only: [prepare_url: 2]
  alias Elastix.{HTTP, JSON}

  def clone(elastic_url, index, new_index_name, data \\ %{}) do
    #set index to read-only
    set_read_only(elastic_url, index)
    prepare_url(elastic_url, "/#{index}/_clone/#{new_index_name}")
    |> HTTP.post(JSON.encode!(data))
  end

  def set_read_only(elastic_url, index) do
    data = %{
      "settings" => %{
        "index.blocks.read_only" => true
      }
    }
    prepare_url(elastic_url, "/#{index}/_settings")
    |> HTTP.put(JSON.encode!(data))
    |> IO.inspect()
  end
end
