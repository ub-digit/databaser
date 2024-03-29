
defmodule DbListAdmin.Resource.Topic do
  alias DbListAdmin.Model
  alias DbListAdmin.Repo
  alias DbListAdmin.Resource.Topic.Create
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

  def show(%{topic: %{id: id}}) do
    show(id)
  end

  def show(id) do
    (from t in topics_base(),
    where: t.id == ^id)
    |> Repo.all()
    |> Enum.map(fn item -> Model.Topic.remap(item) end)
    |> List.first()
  end

  def save(data) do
    Create.create_or_update(data)
    |> case do
      {:error, _, error, _}  -> error
      {:ok, result}       -> show(result)
    end
  end
end
