defmodule Databases.Repo do
  use Ecto.Repo,
    otp_app: :databases,
    adapter: Ecto.Adapters.Postgres
end
