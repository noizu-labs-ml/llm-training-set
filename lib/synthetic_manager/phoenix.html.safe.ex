
defimpl Phoenix.HTML.Safe, for: Ecto.Changeset do
  def to_iodata(%{data: %SyntheticManager.Features.Feature{}} = cs) do
    cs.data.id
    #"#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}"
    #|> IO.iodata_to_binary()
  end
  def to_iodata(cs) do
    cs
    #"#{Phoenix.HTML.Engine.html_escape(feature.name)} - #{Phoenix.HTML.Engine.html_escape(feature.description)}"
    #|> IO.iodata_to_binary()
  end
end
