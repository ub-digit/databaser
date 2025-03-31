defmodule DbListAdmin.Model.TermsOfUse do
  def get_default_terms_of_use do
    [
      %{code: "print_article_chapter", permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "download_article_chapter", permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "course_pack_print", permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "gul_course_pack_electronic", permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "scholarly_sharing", permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "interlibrary_loan", permitted: "N/A", description_en: "", description_sv: "", has_options: true},
      %{code: "ai_rules", description_en: "", description_sv: "", has_options: false}
    ]
  end
end
