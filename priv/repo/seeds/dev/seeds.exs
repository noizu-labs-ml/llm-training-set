# List of subscript files to be executed
subscript_files = ["seed_features.exs","seed_organizations.exs", "seed_users.exs"]

# Execute each subscript
dir = Path.dirname(__ENV__.file)
for file <- subscript_files do
  Code.eval_file("#{dir}/#{file}")
end
