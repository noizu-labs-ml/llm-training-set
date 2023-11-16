defmodule SyntheticManager.Features.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "feature" do
    # Standard Fields
    field :name, :string
    field :category, Ecto.Enum, values: SyntheticManager.FeatureCategoryEnum.values()
    field :description, :string
    field :status, Ecto.Enum, values: SyntheticManager.EntityStatusEnum.values()
    field :meta, :map, default: %{}

    # # Time Stamps
    timestamps(type: :utc_datetime_usec, null: true)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :category, :description, :status, :meta])
    |> validate_required([:name, :category])
  end


  defimpl Phoenix.HTML.Safe do
    def to_iodata(x) do
      x.id
      #  "#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}" |> IO.iodata_to_binary()
    end
  end
end
