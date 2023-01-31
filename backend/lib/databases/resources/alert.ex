defmodule Databases.Resource.Alert do
  def fetch() do
    Databases.Model.Alert.get()
  end
end
