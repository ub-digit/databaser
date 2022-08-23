defmodule DbListAdmin.Model.Publisher do
  use Ecto.Schema
  import Ecto.Changeset
  alias DbListAdmin.Model
  alias DbListAdmin.Repo

  schema "publishers" do
    field :name, :string
    has_many :database_publishers, Model.DatabasePublisher
  end

  def remap(%{} = publisher) do
    %{
      id: publisher.id,
      name: publisher.name,
      can_be_deleted: can_be_deleted(publisher)
    }
  end

  def can_be_deleted(%{:database_publishers => db_publishers}) when is_list(db_publishers) do
    length(db_publishers) < 1
  end

  def can_be_deleted(_) do
    true
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
      media_type: error_list
      }
    }
  end

  def find(id) when is_nil(id), do: %Model.Publisher{}
  def find(id) do
    Repo.get!(Model.Publisher, id) |> Repo.preload([:database_publishers])
  end

  @doc false
  def changeset(%Model.Publisher{} = publisher, attrs) do
    publisher
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :publishers_name_key)
  end
end
