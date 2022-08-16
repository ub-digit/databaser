defmodule DbListAdminWeb.TermsOfUseController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.TermsOfUse.default()
  end
end
