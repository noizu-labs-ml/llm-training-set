defmodule SyntheticManager.Repo.Migrations.FeatureCategoryEnum do
  use Ecto.Migration

  def up do
    # Create synthetic_feature enum
    execute "CREATE TYPE feature_category AS ENUM (
      'basic_syntax',
      'code_block',
      'prompt_prefix',
      'directive',
      'agent',
      'runtime_flag',
      'other'
    )"
  end

  def down do
    # Drop synthetic_feature enum
    execute "DROP TYPE feature_category"

  end
end
