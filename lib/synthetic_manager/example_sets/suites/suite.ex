
defmodule SyntheticManager.ExampleSet.Suites.Suite do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "example_set_suite" do
    # Basic Fields
    field :name, :string
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values()
    field :description, :string
    field :meta, :map, default: %{}

    # Belongs To
    belongs_to :user, SyntheticManager.Users.User
    belongs_to :organization, SyntheticManager.Organizations.Organization

    # Many To Many Fields
    many_to_many :example_sets,
                 SyntheticManager.ExampleSets.ExampleSet,
                 join_through: SyntheticManager.ExampleSet.Suites.ExampleSetSuiteExampleSet,
                 join_keys: [example_set_suite_id: :id, example_set_id: :id],
                 on_replace: :delete

    # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :status, :description, :meta])
    |> validate_required([:name])
  end


  defimpl Phoenix.HTML.Safe do
    def to_iodata(x) do
      "#{x.id}"
      #  "#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}" |> IO.iodata_to_binary()
    end
  end
end
