defmodule DbListAdmin.Model.Alert do

  def alert_message_file_path do
    System.get_env("ALERT_MESSAGE_PATH", "../data/alert.json")
  end
  def get() do
    File.read(alert_message_file_path())
    |> case do
      {:error, _} -> %{sv: "", en: "", show: false}
      {:ok, content} -> content |> Jason.decode!()
    end
  end

  def set(data) do
    file = File.open!(alert_message_file_path(), [:write])
    IO.binwrite(file, Jason.encode!(data))
    File.close(file)
    data
  end
end
