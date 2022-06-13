defmodule Databases.Model.Publisher do
  use Ecto.Schema
  alias Databases.Model

  schema "publishers" do
    field :name, :string
    has_many :database_publishers, Model.DatabasePublisher
  end



  def remap(%Model.Publisher{} = publisher) do
    %{
      id: publisher.id,
      name: publisher.name
    }
  end
end
