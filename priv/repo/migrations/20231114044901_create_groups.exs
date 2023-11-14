defmodule SyntheticManager.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:synthetic_groups) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
