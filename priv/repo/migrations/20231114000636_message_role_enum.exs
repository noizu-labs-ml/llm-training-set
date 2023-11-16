defmodule SyntheticManager.Repo.Migrations.MessageRoleEnum do
  use Ecto.Migration

  def up do
    # Create synthetic_feature enum
    execute "CREATE TYPE message_role AS ENUM (
      'user',
      'assistant',
      'system',
      'function',
      'function_call',
      'function_response',
      'other',
      'unknown'
    )"
  end

  def down do
    # Drop synthetic_feature enum
    execute "DROP TYPE feature_category"

  end
end
