defmodule SyntheticManager.Synthetics.SyntheticFeature do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "synthetic_feature" do
    # Belongs To
    belongs_to :feature, SyntheticManager.Features.Feature, type: Ecto.UUID
    belongs_to :synthetic, SyntheticManager.Synthetics.Synthetic, type: Ecto.UUID

    # Standard Fields
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values(), default: :pending
    field :meta, :map, default: %{}

    # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    IO.inspect(feature, label: "SyntheticFeature")
    feature
    |> cast(attrs, [:feature, :synthetic, :status])
    |> validate_required([:feature, :synthetic])
  end
end
