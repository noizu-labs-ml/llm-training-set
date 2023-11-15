defmodule SyntheticManager.Repo.Migrations.CreateSynthetics do
  use Ecto.Migration

  def change do


    create table(:synthetic) do
      add :name, :string, length: 256
      add :description, :text
      add :hidden_prompt, :text
      add :messages, :jsonb
      add :created_by, :string, length: 64
      timestamps(type: :utc_datetime_usec)
    end

    create table(:synthetic_feature) do
      add :feature_id, references(:feature)
      add :synthetic_id, references(:synthetic)
      timestamps(type: :utc_datetime_usec)
    end

  end
end
