
defmodule SyntheticManager.ExampleSets.ExampleSet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "example_set" do
    # Basic Fields
    field :name, :string
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values()
    field :description, :string
    field :meta, :map, default: %{}

    # Belongs To
    belongs_to :user, SyntheticManager.Users.User
    belongs_to :organization, SyntheticManager.Organizations.Organization

    # Many to Many
    many_to_many :synthetics,
                 SyntheticManager.Synthetics.Synthetic,
                 join_through: SyntheticManager.ExampleSets.ExampleSetSynthetic,
                 join_keys: [example_set_id: :id, synthetic_id: :id],
                 on_replace: :delete

    # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :status, :description, :user, :organization, :meta])
    |> validate_required([:name])
  end


  defimpl Phoenix.HTML.Safe do
    def to_iodata(x) do
      "#{x.id}"
      #  "#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}" |> IO.iodata_to_binary()
    end
  end
end
