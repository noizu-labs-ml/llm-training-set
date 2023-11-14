defmodule SyntheticManager.Features.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "features" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
