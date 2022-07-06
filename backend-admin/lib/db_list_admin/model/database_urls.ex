defmodule DbListAdmin.Model.DatabaseUrl do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model

  schema "database_urls" do
    field :title, :string
    belongs_to :database, DbListAdmin.Model.Database
    field :url, :string
  end

  def remap(%{} = url) do
    %{
      title: url.title,
      url: url.url
    }
  end

  def remap_error(error) do
    error_list =
    error
    |> Enum.map(fn {k, {_, reason}} ->
        {r1, r2} = List.first(reason)
        %{:field => k, :error_code => Atom.to_string(r1) <> "_" <> Atom.to_string(r2)}
      end)

    %{
      error: %{
        database_url: error_list
      }
    }
  end

  def changeset(%Model.DatabaseUrl{} = database_url, attrs) do
    database_url
    |> cast(attrs, [:title, :url, :database_id])
    |> validate_required([:url])
    |> validate_required([:database_id])

  end
end
