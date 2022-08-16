defmodule DbListAdmin.Model.DatabaseTermsOfUse do
  use Ecto.Schema
  alias DbListAdmin.Model
  import Ecto.Changeset

  schema "database_terms_of_use" do
    belongs_to :database, Model.Database
    field :code, :string
    field :description_en, :string
    field :description_sv, :string
    field :permitted, :boolean
  end

  def remap(%{} = database_terms_of_use) do
    %{
      permitted: database_terms_of_use.permitted,
      description_en: database_terms_of_use.description_en,
      description_sv: database_terms_of_use.description_sv,
      code: database_terms_of_use.code,
      id: database_terms_of_use.id
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
        terms_of_use: error_list
      }
    }
  end

  def get_default_set do
    [
      %{code: "print_article_chapter", permitted: "N/A", description_en: "", description_se: ""},
      %{code: "download_article_chapter", permitted: "N/A", description_en: "", description_se: ""},
      %{code: "course_pack_print", permitted: "N/A", description_en: "", description_se: ""},
      %{code: "gul_course_pack_electronic", permitted: "N/A", description_en: "", description_se: ""},
      %{code: "scholarly_sharing", permitted: "N/A", description_en: "", description_se: ""},
      %{code: "interlibrary_loan", permitted: "N/A", description_en: "", description_se: ""},
    ]
  end

  def deserialize_terms_of_use(tou) do
    tou
    |> Enum.filter(fn t -> Map.get(t, :permitted) != "N/A" end)
    |> Enum.map(fn t ->
      case Map.get(t, :permitted) do
         "yes"  -> Map.put(t, :permitted, true)
         "no"   -> Map.put(t, :permitted, false)
      end
    end)
  end

  def serialize_terms_of_use(tou) do
    get_default_set()
    |> Enum.map(fn default_tou ->
      state = Enum.filter(tou, fn t -> t.code == default_tou.code end)
      |> List.first()
      |> get_tou_state()
      Map.put(default_tou, :permitted, state)
    end)
  end

  def get_tou_state(tou) when is_nil(tou), do: "N/A"

  def get_tou_state(tou) do
    Map.get(tou, :permitted)
    |> case do
      true -> "yes"
      false -> "no"
    end
  end

  def changeset(database_terms_of_use, attrs) do
    database_terms_of_use
    |> cast(attrs, [:database_id, :code, :description_en, :description_sv, :permitted])
    |> validate_required([:code])
    |> validate_required([:permitted])
  end
end
