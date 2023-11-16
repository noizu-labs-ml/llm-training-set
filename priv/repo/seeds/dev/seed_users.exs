alias SyntheticManager.Users
tag_one = "initial-users"
alias SyntheticManager.Users, as: Users
unless SyntheticManager.Repo.get(SyntheticManager.SeedTags.Tag, tag_one)  do
  now = DateTime.utc_now()
  template = %{name: nil, bio: nil, inserted_at: now, updated_at: now}

  # Basic Syntax Features
  %{template | name: "Keith Brings.", bio: "Founder"}
  |> Users.create_user()

  IO.puts "[#{tag_one}] Executed"
  SyntheticManager.Repo.insert!(%SyntheticManager.SeedTags.Tag{name: tag_one, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})
else
  IO.puts "[#{tag_one}] Already Applied"
end
