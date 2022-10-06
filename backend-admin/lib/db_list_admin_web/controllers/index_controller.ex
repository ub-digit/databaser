defmodule DbListAdminWeb.IndexController do
  use DbListAdminWeb, :controller

  def reindex_admin_index(conn, params) do
    reindex = Map.get(params, "reindex", false) == "true"
    case reindex do
      false -> json conn, %{error: "no reindexing done, pass '?reindex=true' "}
      true -> json conn, DbListAdmin.Resource.Elastic.Index.initialize()
    end

  end
end
