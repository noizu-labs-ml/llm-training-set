defmodule SyntheticManager.Repo.Migrations.EntityStatusEnum do
  use Ecto.Migration

  def up do
    # Create synthetic_feature enum
    execute "CREATE TYPE entity_status AS ENUM (
      'enabled',
      'disabled',
      'deleted',
      'review',
      'pending',
      'unknown',
      'other'
    )"
  end

  def down do
    # Drop synthetic_feature enum
    execute "DROP TYPE entity_status"

  end
end
