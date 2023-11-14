# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Synthetics.Repo.insert!(%Synthetics.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
dir = Path.dirname(__ENV__.file)
Code.eval_file("#{dir}/seeds/#{Mix.env}/seeds.exs")
