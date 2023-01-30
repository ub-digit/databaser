defmodule DbListAdmin.Resource.Alert do
  def fetch do
    DbListAdmin.Model.Alert.get()
  end

  def set(params) do
    DbListAdmin.Model.Alert.set(params)
  end
end
