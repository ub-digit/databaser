defmodule Databases.Resource.DublinCore.Translations do
  def dictionary do
     %{
       # Terms of use
       "download_article_chapter" => "Ladda ner artikel eller kapitel",
       "course_pack_print" => "Trycka kurskompendium",
       "gul_course_pack_electronic" => "Ladda upp kurskompendium på lärplattform",
       "scholarly_sharing" => "Scholarly sharing",
       "interlibrary_loan" => "Fjärrlån",
       "ai_rules" => "AI",
       "print_article_chapter" => "Skriva ut artikel eller kapitel",
       "permitted" => "Tillåtet",
       "not_permitted" => "Inte tillåtet",
       # Access information
       "freely_available" => "Fritt tillgänglig",
       "available_to_the_university_of_gothenburg" =>
         "Tillgänglig för Göteborgs universitet",
       "available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone" =>
         "Tillgänglig för Göteborgs universitet, endast på campus. Tillgänglig för alla från bibliotekens datorer",
       "available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers" =>
         "Tillgänglig för Göteborgs universitet. Tillgänglig för alla från bibliotekens datorer",
     }
   end
 end
