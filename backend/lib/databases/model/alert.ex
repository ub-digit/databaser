defmodule Databases.Model.Alert do

  def alert_message_file_path do
    System.get_env("ALERT_MESSAGE_PATH", "../data/alert.json")
  end

  def get(lang) do
    File.read(alert_message_file_path())
    |> case do
      {:error, _} -> %{"sv" => "", "en" => "", "show_alert_message" => false}
      {:ok, content} -> content |> Jason.decode!()
    end
    |> remap(lang)
  end

  def remap(data, lang) do
    %{
      message: data[lang],
      show: data["show_alert_message"]
    }
  end
end
