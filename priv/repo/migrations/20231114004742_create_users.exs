defmodule SyntheticManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string, length: 128, null: false, unique: true, comment: "Name of Creator"
      add :bio, :text,  null: true, comment: "Background Blurb"


      add :profile_picture, :string, null: true, unique: true, comment: "User Profile Picture Link"
      add :email, :string, null: true, unique: true, comment: "User Login"
      add :pass, :string, null: true, unique: false, comment: "User Password Hash"

      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end
  end
end
