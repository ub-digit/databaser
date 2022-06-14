defmodule DbListAdmin.Resource.Topic.SubTopic do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  import Ecto.Query

  def sub_topic_can_be_deleted(topic) do
    connections = (from database_sub_topics in Model.DatabaseSubTopic,
    preload: [:sub_topic])
    |> Repo.all()
    |> Enum.map(fn item -> item.sub_topic.id end)
    sub_topics = Map.get(topic, :sub_topics)
    |> Enum.map(fn item ->
      Map.put(item, :can_be_deleted, Enum.member?(connections, item[:id]) != true)
    end)
    Map.put(topic, :sub_topics, sub_topics)
  end
end
