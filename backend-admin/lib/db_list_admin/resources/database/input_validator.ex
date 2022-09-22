defmodule DbListAdmin.Resource.Database.InputValidator do
  def validate_input(data) do
    errors =
    %{}
    |> parse_list_property(data["publishers"], "publisher")
    |> parse_list_property(data["topics"], "topic")
    |> parse_string_property(data["title_en"], "title_en")
    |> parse_string_property(data["title_sv"], "title_sv")
    |> Enum.map(fn item -> elem(item, 1) end)

    case length(errors) do
      0 -> {:ok, data}
      _ -> {:error, errors}
    end
  end

  def parse_list_property(error_map, nil, type), do: Map.put(error_map, String.to_atom(type), type <> " required")
  def parse_list_property(error_map, [], type), do: Map.put(error_map, String.to_atom(type), type <> " required")
  def parse_list_property(error_map, val, _) when length(val) > 0, do: error_map

  def parse_string_property(error_map, "", type), do: Map.put(error_map, String.to_atom(type), type <> " required")
  def parse_string_property(error_map, nil, type), do: Map.put(error_map, String.to_atom(type), type <> " required")
  def parse_string_property(error_map, string, _) when is_bitstring(string), do: error_map
end
