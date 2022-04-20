defmodule Databases.Model.DatabaseUrl do
    use Ecto.Schema
    import Ecto.Changeset
    alias Databases.Model
  
    schema "database_urls" do
      field :title, :string
      belongs_to :database, Databases.Model.Database 
      field :url, :string
    end
  
# TODO: url should not be set twice
    def remap(%{title: ""} = url, title) do
      %{
        title: title,
        url: url.url
      }
    end

    def remap(url, title) do
      %{
        title: title <> "(" <> url.title <> ")",
        url: url.url
      }
    end
  
    @doc false
    def changeset(url, attrs) do
      url
      |> cast(attrs, [:title])
      |> validate_required([:title])
    end
  end