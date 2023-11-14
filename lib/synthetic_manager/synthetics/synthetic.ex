defmodule SyntheticManager.Synthetics.Synthetic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "synthetic" do
    field :name, :string
    field :description, :string
    field :hidden_prompt, :string
    many_to_many :features,
                 SyntheticManager.Features.Feature,
                 join_through: SyntheticManager.Synthetics.SyntheticFeature,
                 join_keys: [synthetic_id: :id, feature_id: :id],
                 on_replace: :delete
    field :details, :map, default: %{messages: []}
    field :created_by, :string
    field :feature_list, :string, virtual: true
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :description, :hidden_prompt, :details, :created_by])
    |> cast_assoc(:features)
    |> validate_required([:name, :description, :hidden_prompt, :details, :created_by])
  end
end
