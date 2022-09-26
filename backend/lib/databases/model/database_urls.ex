defmodule Databases.Model.DatabaseUrl do
  use Ecto.Schema

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

  def remap(%{title: nil} = url, title) do
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
end
