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
    Databases.Resource.Search.search(%{"lang" => "sv"})
    |> Map.get(:data)
    |> Enum.map(fn db ->
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
      "dv:identifier" => db["id"],
      "dc:type" => get_data_in_list(db["media_types"]),
      "dc:subject" => get_subjects(db),
      "dc:modified" => db["updated_at"]
    }
  end

  defp get_data_in_list(property) do
    Enum.map(property, fn item -> item["name"] end)
  end

  defp get_subjects(db) do
    db["topics"]
    |> Enum.map(fn sub -> [sub["name"] | Enum.map(sub["sub_topics"], fn st -> st["name"] end)] end)
    |> List.flatten()
  end
end
