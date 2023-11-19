alias SyntheticManager.Groups
alias SyntheticManager.Groups.Group
tag_one = "initial-groups"

unless SyntheticManager.Repo.get(SyntheticManager.SeedTags.Tag, tag_one)  do
  now = DateTime.utc_now()
  template = %{name: nil, description: nil, inserted_at: now, updated_at: now}

  # Basic Syntax Features
  %{template | name: "Misc.", description: "Uncategorized DataSets"}
  |> Groups.create_group()

  IO.puts "[#{tag_one}] Executed"
  SyntheticManager.Repo.insert!(%SyntheticManager.SeedTags.Tag{name: tag_one, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})
else
  IO.puts "[#{tag_one}] Already Applied"
end
