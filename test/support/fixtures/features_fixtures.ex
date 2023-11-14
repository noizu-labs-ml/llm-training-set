defmodule SyntheticManager.FeaturesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SyntheticManager.Features` context.
  """

  @doc """
  Generate a feature.
  """
  def feature_fixture(attrs \\ %{}) do
    {:ok, feature} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> SyntheticManager.Features.create_feature()

    feature
  end
end
