defmodule DbListAdmin.Resource.Elastic do

  @index_admin "databases_admin"
  @index_sv "databases_sv"
  @index_en "databases_en"

  def index_admin, do: @index_admin
  def index_sv, do: @index_sv
  def index_en, do: @index_en

  def elastic_url do
    System.get_env("ELASTIC_SEARCH_URL", "http://localhost:9200")
  end

  def delete_from_index(id) do
    delete_from_index(id, [@index_admin, @index_en, @index_sv])
  end

  def delete_from_index(id, :public) do
    delete_from_index(id, [@index_en, @index_sv])
    add_to_index(id, :admin)
  end

  def delete_from_index(id, indexes) do
    indexes
    |> Enum.map(fn index ->
      Elastix.Document.delete(elastic_url(), index, "_doc", id)
      Elastix.Index.refresh(elastic_url(), index)
    end)
  end

  def add_to_index(id) do
    DbListAdmin.Resource.Database.get_one(id)
    |> update_index(@index_admin)
    |> update_index(@index_sv, "sv")
    |> update_index(@index_en, "en")
  end

  def add_to_index(id, :admin) do
    DbListAdmin.Resource.Database.get_one(id)
    |> update_index(@index_admin)
  end

  def update_index(data, index) do
    Elastix.Document.index(elastic_url(), index, "_doc", data.id, DbListAdmin.Model.Database.remap(data))
    Elastix.Index.refresh(elastic_url(), index)
    data
  end

  def update_index(data, index, lang) do
    # Check for published or not
    case data.published do
      true -> Elastix.Document.index(elastic_url(), index, "_doc", data.id, DbListAdmin.Model.Database.remap(data, lang))
      false -> Elastix.Document.delete(elastic_url(), index, "_doc", data.id)
    end
    Elastix.Index.refresh(elastic_url(), index)
    data
  end
end
