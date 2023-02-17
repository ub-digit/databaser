defmodule Databases.Model.Alert do

  def alert_message_file_path do
    System.get_env("ALERT_MESSAGE_FILE_PATH", "../data") <> "/alert.json"
  end

  def get() do
    File.read(alert_message_file_path())
    |> case do
      {:error, _} -> %{"sv" => "", "en" => "", "show_alert_message" => "error"}
      {:ok, content} -> content |> Jason.decode!()
    end
    |> remap()
  end

  def remap(data) do
    %{
      en: data["en"],
      sv: data["sv"],
      show: data["show_alert_message"]
    }
  end
end
