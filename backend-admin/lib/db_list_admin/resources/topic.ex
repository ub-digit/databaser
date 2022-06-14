
defmodule DbListAdmin.Resource.Topic do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query


  def topics_base do
    from topics in Model.Topic,
    left_join: db_topics in Model.DatabaseTopic,
    on: topics.id == db_topics.topic_id,
    left_join: sub_topics in Model.SubTopic,
    on: topics.id == sub_topics.topic_id,
    preload: [database_topics: db_topics, sub_topics: sub_topics]
  end

  def get_topics() do
    (from t in topics_base())
    |> Repo.all()
    |> Enum.map(fn item -> Model.Topic.remap(item) end)
  end

  @spec topic_can_be_deleted(any) :: list
  def topic_can_be_deleted(topics) do
    IO.inspect(topics, label: "topics in can be deleted")
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

end
