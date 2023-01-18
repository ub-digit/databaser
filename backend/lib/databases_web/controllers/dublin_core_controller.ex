defmodule DatabasesWeb.DublinCoreController do
  use DatabasesWeb, :controller

  def export(conn, _params) do
    text conn, Databases.Resource.DublinCore.create_xml()
  end

end
