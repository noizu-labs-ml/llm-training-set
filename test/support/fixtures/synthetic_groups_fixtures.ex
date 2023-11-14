defmodule SyntheticManager.SyntheticGroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SyntheticManager.SyntheticGroups` context.
  """

  @doc """
  Generate a gr_synthetic_group.
  """
  def gr_synthetic_group_fixture(attrs \\ %{}) do
    {:ok, gr_synthetic_group} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> SyntheticManager.SyntheticGroups.create_gr_synthetic_group()

    gr_synthetic_group
  end
end
