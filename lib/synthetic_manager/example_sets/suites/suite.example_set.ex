defmodule SyntheticManager.ExampleSet.Suites.ExampleSetSuiteExampleSet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "example_set_suite_example_set" do
    # Belongs To
    belongs_to :example_set_suite, SyntheticManager.ExampleSet.Suites.Suite
    belongs_to :example_set, SyntheticManager.ExampleSets.ExampleSet

    # Standard Fields
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values(), default: :unknown
    field :meta, :map, default: %{}

    # TimeStamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:example_set_suite, :example_set, :status, :meta])
    |> validate_required([:example_set_suite, :example_set])
  end
end
