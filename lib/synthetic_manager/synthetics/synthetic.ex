defmodule SyntheticManager.Synthetics.Synthetic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "synthetic" do
    # Standard Fields
    field :name, :string
    field :description, :string
    field :hidden_prompt, :string
    field :functions, :string
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values()
    field :meta, :map, default: %{}

    # Belongs To
    belongs_to :user, SyntheticManager.Users.User, type: Ecto.UUID
    belongs_to :organization, SyntheticManager.Organizations.Organization, type: Ecto.UUID
    belongs_to :group, SyntheticManager.Groups.Group, type: Ecto.UUID

    # Many To Many
    many_to_many :features, SyntheticManager.Features.Feature,
                 join_through: SyntheticManager.Synthetics.SyntheticFeature,
                 join_keys: [synthetic_id: :id, feature_id: :id],
                 on_replace: :delete

    # Embeds
    embeds_many :messages, Message, on_replace: :delete do
      field :features, {:array, :map}
      field :role, Ecto.Enum, values: SyntheticManager.MessageRoleEnum.values(), default: :unknown
      field :content, :string
      field :note, :string
      field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values(), default: :pending
      field :sequence, :integer
      timestamps(type: :utc_datetime_usec, null: true)
    end


    # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    IO.inspect(attrs,label: "CHANGESET-1")
    feature
    |> cast(attrs, [:name, :description, :hidden_prompt, :functions, :group_id, :user_id, :organization_id, :status, :meta])
    |> validate_required([:name])
    |> cast_assoc(:features)
    |> cast_assoc(:user)
    |> cast_assoc(:organization)
    |> cast_assoc(:group)
    |> cast_embed(:messages, with: &message_changeset/2)
  end

  def message_changeset(embedded_item, attrs) do
    IO.inspect(attrs,label: "CHANGESET-2")
    embedded_item
    |> cast(attrs, [:id, :features, :status, :role, :content, :note, :sequence])
  end
end
