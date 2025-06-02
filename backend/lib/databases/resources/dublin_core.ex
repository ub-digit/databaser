defmodule Databases.Resource.DublinCore do
  defp doc do
    %{
      "OAI-PMH" => %{
        "#content" => %{
          "ListRecords" => %{"record" => ""}
          },
        "-xmlns" => "http://www.openarchives.org/OAI/2.0/",
        "-xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "-xsi:schemaLocation" => "http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
      }
    }
  end

  def create_xml do
    doc()
    |> put_in(["OAI-PMH", "#content", "ListRecords", "record"], map_databases())
    |> MapToXml.from_map()
  end

  defp map_databases() do
    Databases.Resource.Search.search(%{"lang" => "sv", "published" => true})
    |> Map.get(:data)
    |> Enum.take(1)
    |> Enum.map(fn db ->
      IO.inspect(db)
      db = Databases.Resource.Search.sort_terms_of_use(db)
      %{
        "header" => %{
          "identifier" => "oai:ubnext/databases/#{db["id"]}",
          "datestamp" => db["updated_at"]
        },
        "metadata" => %{
          "oai_dc:dc" => %{
            "#content" => extract_content(db),
            "-xmlns:oai_dc" => "http://www.openarchives.org/OAI/2.0/oai_dc/",
            "-xmlns:dc" => "http://purl.org/dc/elements/1.1/",
            "-xmlns:dcterms" => "http://purl.org/dc/terms/",
            "-xsi:schemaLocation" => "http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"
          }
        }
      }
    end)
  end

  defp extract_content(db) do
    %{
      "dc:title" => db["title"],
      "dc:description" => db["description"],
      "dc:publisher" => get_data_in_list(db["publishers"]),
      "dc:identifier" => db["id"],
      "dc:type" => get_data_in_list(db["media_types"]),
      "dc:subject" => get_subjects(db),
      "dc:modified" => db["updated_at"],
      "dc:rights" => get_terms_of_use(db["terms_of_use"]),
      "dcterms:accessRights" => Databases.Resource.DublinCore.Translations.dictionary()[db["access_information_code"]]
    }
    |> Enum.reject(fn {_, v} -> v == nil end)
    |> Map.new()
  end

  defp get_terms_of_use(nil), do: nil
  defp get_terms_of_use([]), do: nil
  defp get_terms_of_use(terms_of_use) do
    terms_of_use

    |> Enum.map(fn item ->
      case item["has_options"] do
        true -> compose_terms_of_use_string(item["code"], item["permitted"])
        false -> get_ai(item)
      end
    end)
    |> Enum.reject(&is_nil/1)
  end



  defp get_data_in_list(property) do
    Enum.map(property, fn item -> item["name"] end)
  end

  defp get_subjects(db) do
    db["topics"]
    |> Enum.map(fn sub -> [sub["name"] | Enum.map(sub["sub_topics"], fn st -> st["name"] end)] end)
    |> List.flatten()
  end

  defp compose_terms_of_use_string(code, permitted) do
    Databases.Resource.DublinCore.Translations.dictionary()[code] <> " - " <>
    case permitted do
      true ->
        Databases.Resource.DublinCore.Translations.dictionary()["permitted"]
      false ->
        Databases.Resource.DublinCore.Translations.dictionary()["not_permitted"]
    end
  end

  defp get_ai(item) do
    "AI - " <> item["description"]
  end
end
