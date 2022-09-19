defmodule DbListAdminWeb.IndexController do
  use DbListAdminWeb, :controller

  def reindex_admin_index(conn, params) do
    reindex = Map.get(params, "reindex", false) == "true"
    IO.inspect(reindex, label: "REINDEX")
    json conn, DbListAdmin.Resource.Elastic.reindex(reindex)
  end
end
