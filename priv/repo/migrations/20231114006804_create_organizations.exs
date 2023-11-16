defmodule SyntheticManager.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organization) do
      add :name, :string,  null: false, unique: true, comment: "Name of the organization"
      add :description, :text, null: true, comment: "Organization Details"
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end
  end
end
