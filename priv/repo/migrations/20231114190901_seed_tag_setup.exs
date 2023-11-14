defmodule SyntheticManager.Repo.Migrations.SeedTagSetup do
  use Ecto.Migration

  def change do
    create table(:seed_tag, primary_key: false) do
      add :name, :string, primary_key: true
      timestamps(type: :utc_datetime_usec)
    end
  end
end
