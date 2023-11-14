defmodule SyntheticManager.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:feature) do
      add :name, :string
      add :category, :feature_category
      add :description, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
