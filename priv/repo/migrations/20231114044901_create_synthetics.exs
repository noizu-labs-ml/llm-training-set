defmodule SyntheticManager.Repo.Migrations.CreateSynthetics do
  use Ecto.Migration

  def change do

    create table(:synthetic) do
      add :name, :string, length: 256, null: true
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :description, :text, null: true
      add :functions, :text, null: true
      add :hidden_prompt, :text, null: true
      add :meta, :jsonb, null: true
      add :messages, :jsonb, null: true
      add :user_id, references(:user), null: true
      add :organization_id, references(:organization), null: true
      timestamps(type: :utc_datetime_usec, null: true)
    end

    create table(:synthetic_feature) do
      add :feature_id, references(:feature, on_delete: :delete_all)
      add :synthetic_id, references(:synthetic, on_delete: :delete_all)
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end

    create table(:example_set_suite) do
      add :name, :string, length: 256, null: true
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :description, :text, null: true
      add :meta, :jsonb
      add :user_id, references(:user), null: true
      add :organization_id, references(:organization), null: true
      timestamps(type: :utc_datetime_usec, null: true)
    end

    create table(:example_set) do
      add :name, :string, length: 256, nul: true
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :description, :text, null: true
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end


    create table(:example_set_suite_example_set) do
      add :example_suite_id, references(:example_set_suite, on_delete: :delete_all)
      add :example_set_id, references(:example_set, on_delete: :delete_all)
      add :name, :string, length: 256
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :description, :text, null: true
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end

    create table(:example_set_synthetic) do
      add :synthetic_id, references(:synthetic, on_delete: :delete_all)
      add :example_set_id, references(:example_set_suite, on_delete: :delete_all)

      add :name, :string, length: 256, null: true
      add :status, SyntheticManager.EntityStatusEnum.type, null: false, default: "pending", comment: "Active, Pending, Disabled, Review"
      add :description, :text, null: true
      add :meta, :jsonb
      timestamps(type: :utc_datetime_usec, null: true)
    end


  end
end
