defmodule SyntheticManager.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "organization" do
    # Standard Fields
    field :name, :string
    field :description, :string
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values()
    field :meta, :map, default: %{}

    # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :description, :status, :meta])
    |> validate_required([:name])
  end
end
