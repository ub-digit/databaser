defmodule DbListAdmin.Repo.Migrations.AddFieldsAlternativeNamesToTopicsSubTopicsAndMediaTypes do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :alternative_names_en, :citext
      add :alternative_names_sv, :citext
    end

    alter table(:sub_topics) do
      add :alternative_names_en, :citext
      add :alternative_names_sv, :citext
    end

    alter table(:media_types) do
      add :alternative_names_en, :citext
      add :alternative_names_sv, :citext
    end
  end
end
