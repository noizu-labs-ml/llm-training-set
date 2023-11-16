

defmodule SyntheticManager.EntityStatusEnum do
  def type(), do: :entity_status
  def values(), do: [:enabled, :disabled, :deleted, :review, :pending, :unknown, :other]
end

defmodule SyntheticManager.MessageRoleEnum do
  def type(), do: :message_role
  def values(), do: [:user, :assistant, :function, :function_call, :function_response, :other, :unknown]
end

defmodule SyntheticManager.FeatureCategoryEnum do
  def type(), do: :feature_category
  def values(), do: [:basic_syntax, :code_block, :propt_prefix, :directive, :agent, :runtime_flag, :other, :unknown]
end
