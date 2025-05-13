defmodule Databases.Model.TermsOfUse do
  def get_default_terms_of_use do
    [
      %{code: "print_article_chapter", order: 1, permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "download_article_chapter", order: 2, permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "course_pack_print", order: 3, permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "gul_course_pack_electronic", order: 4, permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "scholarly_sharing", order: 5, permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "interlibrary_loan", order: 6, permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "ai_rules", order: 7, permitted: nil, description_en: "", description_sv: "", has_options: false}
    ]
  end
end
