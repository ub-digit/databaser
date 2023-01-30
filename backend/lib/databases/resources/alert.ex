defmodule Databases.Resource.Alert do
  def fetch(params) do
    Databases.Model.Alert.get(params["lang"] || "sv")
  end
end
