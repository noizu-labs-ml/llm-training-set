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
    embeds_many :messages, Message, on_replace: :delete do
      field :role, :string
      field :content, :string
      field :note, :string
      field :sequence, :integer
    end
    #field :my_jsonb_field, {:array, SyntheticManager.Synthetics.Synthetic.Message}, default: [], use: :jsonb
    field :created_by, :string
    timestamps(type: :utc_datetime_usec)
  end


  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :description, :hidden_prompt, :created_by])
    |> cast_assoc(:features)
    |> cast_embed(:messages, with: &message_changeset/2)
    |> validate_required([:name, :description, :hidden_prompt, :created_by])
  end

  def message_changeset(embedded_item, attrs) do
    embedded_item
    |> cast(attrs, [:id, :sequence, :role, :content, :note])
  end
end
