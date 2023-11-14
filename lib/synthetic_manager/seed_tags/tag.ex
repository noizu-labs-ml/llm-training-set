defmodule SyntheticManager.SeedTags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "seed_tag" do
    field :name, :string, primary_key: true
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
