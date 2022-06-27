defmodule Experiment do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query


  def test() do
    delete_data = %{
      "id" => 1006,
      "name_sv" => "TEST TOPIC (sv)",
      "name_en" => "TEST TOPIC (en)",
      "sub_topics" => [
        %{"name_sv" => "sub topic 1 sv", "name_en" => "sub topic 1 en", "id" => 1001, "delete" => true},
        %{"name_sv" => "sub topic 2 sv", "name_en" => "sub topic 2 en", "id" => 1002, "delete" => true},
        %{"name_sv" => "sub topic 3 sv", "name_en" => "sub topic 3 en", "id" => 1003, "delete" => true}
      ]
    }
    DbListAdmin.Resource.Topic.Create.create_or_update(delete_data)
  end

  def check_delete() do
    topics = DbListAdmin.Resource.Topic.get_topics()
    connections = (from database_topics in Model.DatabaseTopic,
    preload: [:topic])
    |> Repo.all()
    |> Enum.map(fn item -> Map.get(Map.get(item, :topic), :id) end)
    |> Enum.uniq()

    topics
    |> Enum.map(fn topic ->
      Map.put(topic, :can_be_deleted, Enum.member?(connections, topic[:id]) == false)
    end)
  end

  def topics_base do
    from topics in Model.Topic,
    left_join: db_topics in Model.DatabaseTopic,
    on: topics.id == db_topics.topic_id,
    left_join: sub_topics in Model.SubTopic,
    on: topics.id == sub_topics.topic_id,
    preload: [:database_topics, :sub_topics]
  end

  def base do
    (from t in topics_base())
    |> Repo.all()
    |> Enum.map(fn item -> Model.Topic.remap(item) end)
  end

  def create_media_type do
    data = %{
      #"id" => 391,
      "name_en" => "test media type sv",
      "name_sv" => "test media type en"
      }
      DbListAdmin.Resource.MediaType.create_or_update(data)
  end


  def create_pub do
    data = %{
      "name" => "Fine Publisher"
    }
    DbListAdmin.Resource.Publisher.create_or_update(data)
  end

  def delete_puiblisher(id) do
    DbListAdmin.Resource.Publisher.delete(id)
  end

  def get_titles() do
    Repo.all(Model.DatabaseAlternativeTitle)
    |> Enum.map(fn item -> Model.DatabaseAlternativeTitle.remap(item) end)
  end



  def delete_all_urls_with_database_id(id) do
    (from url in Model.DatabaseUrl,
    where: url.database_id == ^id)
    |> Repo.delete_all()
  end


end
