defmodule SyntheticManager.Features.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feature" do
    field :name, :string
    field :category, Ecto.Enum, values: [
                                  :basic_syntax,
                                  :code_block,
                                  :prompt_prefix,
                                  :directive,
                                  :agent,
                                  :runtime_flag,
                                  :other]
    field :description, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :category, :description])
    |> validate_required([:name, :category, :description])
  end


  defimpl Phoenix.HTML.Safe do
    def to_iodata(feature) do
      "#{feature.id}"
      #  "#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}" |> IO.iodata_to_binary()
    end
  end
end

defimpl Phoenix.HTML.Safe, for: Ecto.Changeset do
  def to_iodata(%{data: %SyntheticManager.Features.Feature{}} = cs) do
    "#{cs.data.id}"
    #"#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}"
    #|> IO.iodata_to_binary()
  end
end
