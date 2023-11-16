defmodule SyntheticManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "user" do
    # Standard Fields
    field :name, :string
    field :bio, :string
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values()
    field :meta, :map, default: %{}

    field :email, :string
    field :pass, :string

    # Time Stamps
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :bio, :status, :meta])
    |> validate_required([:name])
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(x) do
      UUID.binary_to_string!(x.id)
      #  "#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}" |> IO.iodata_to_binary()
    end
  end
end
