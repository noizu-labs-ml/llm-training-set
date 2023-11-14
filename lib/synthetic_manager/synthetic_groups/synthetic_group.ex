defmodule SyntheticManager.SyntheticGroups.SyntheticGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "synthetic_groups" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
