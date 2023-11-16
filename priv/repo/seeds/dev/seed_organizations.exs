alias SyntheticManager.Organizations
tag_one = "initial-orgs"
alias SyntheticManager.Organizations
unless SyntheticManager.Repo.get(SyntheticManager.SeedTags.Tag, tag_one)  do
  now = DateTime.utc_now()
  template = %{name: nil, description: nil, inserted_at: now, updated_at: now}

  # Basic Syntax Features
  %{template | name: "Noizu Labs, Inc.", description: "Noizu."}
  |> Organizations.create_organization()

  IO.puts "[#{tag_one}] Executed"
  SyntheticManager.Repo.insert!(%SyntheticManager.SeedTags.Tag{name: tag_one, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})
else
  IO.puts "[#{tag_one}] Already Applied"
end
