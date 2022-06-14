defmodule DbListAdmin.Repo do
  use Ecto.Repo,
    otp_app: :db_list_admin,
    adapter: Ecto.Adapters.Postgres
end
