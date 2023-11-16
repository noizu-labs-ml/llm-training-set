defmodule SyntheticManager.Repo.Migrations.CreateFeatures do
  use Ecto.Migration

  def change do
    create table(:feature) do
      add :name, :string, comment: "Feature Name", null: false, unique: true
      add :category, SyntheticManager.FeatureCategoryEnum.type, null: false, default: "unknown", comment: "Feature Category"
      add :description, :string, null: true, comment: "Feature Description"
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end
  end
end
