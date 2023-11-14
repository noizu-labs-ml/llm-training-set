defmodule SyntheticManager.Repo do
  use Ecto.Repo,
    otp_app: :synthetic_manager,
    adapter: Ecto.Adapters.Postgres
end
