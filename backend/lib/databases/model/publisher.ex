defmodule Databases.Model.Publisher do
  use Ecto.Schema
  import Ecto.Changeset
  alias Databases.Model

  schema "publishers" do
    #field :title_en, :string
    #field :title_sv, :string
    field :name, :string
    has_many :database_publishers, Model.DatabasePublisher 
  end

  def remap(a, b) do
    %{
      id: a.id,
      name: a.name
    }
  end

  def remap(%Model.Publisher{} = publisher, lang \\ "sv") do
    %{
      id: publisher.id,
      name: publisher.name
      #title: Map.from_struct(publisher)[String.to_existing_atom("title_" <> lang)] || publisher.title_sv
    }
  end

  @doc false
  def changeset(publisher, attrs) do
    publisher
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
