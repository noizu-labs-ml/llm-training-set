defmodule SyntheticManager.Synthetics.SyntheticFeature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "synthetic_feature" do
    belongs_to :feature, SyntheticManager.Features.Feature
    belongs_to :synthetic, SyntheticManager.Synthetics.Synthetic
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:feature, :synthetic])
    |> validate_required([:feature, :synthetic])
  end
end
