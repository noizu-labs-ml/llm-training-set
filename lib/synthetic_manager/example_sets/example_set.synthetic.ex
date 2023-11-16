defmodule SyntheticManager.ExampleSets.ExampleSetSynthetic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "example_set_synthetic" do
    # Belongs To
    belongs_to :example_set, SyntheticManager.ExampleSets.ExampleSet
    belongs_to :synthetic, SyntheticManager.Synthetics.Synthetic

    # Standard Fields
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values(), default: :unknown
    field :meta, :map, default: %{}

    # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:example_set, :synthetic, :status, :meta])
    |> validate_required([:example_set, :synthetic])
  end
end
