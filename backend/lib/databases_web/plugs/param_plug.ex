defmodule DatabasesWeb.ParamPlug do
  alias Phoenix.LiveView.Plug
  alias Plug.Cowboy.Conn
  def init(_), do: nil

  def call(conn, _) do
    conn
    |> Conn.Plug.fetch_query_params()
    |> IO.inspect(label: "QUERY PARAMS")
    conn
  end
end
