defmodule DbListAdminWeb.TermsOfUseController do
  use DbListAdminWeb, :controller

  def index(conn, _params) do
    json conn, DbListAdmin.Resource.Database.Remapper.get_default_terms_of_use()
  end
end
