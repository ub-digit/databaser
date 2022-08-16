defmodule DbListAdminWeb.TermsOfUseController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Model.DatabaseTermsOfUse.get_default_set()
  end
end
