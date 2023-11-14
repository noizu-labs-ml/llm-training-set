defmodule SyntheticManager.FeaturesTest do
  use SyntheticManager.DataCase

  alias SyntheticManager.Features

  describe "features" do
    alias SyntheticManager.Features.Feature

    import SyntheticManager.FeaturesFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_features/0 returns all features" do
      feature = feature_fixture()
      assert Features.list_features() == [feature]
    end

    test "get_feature!/1 returns the feature with given id" do
      feature = feature_fixture()
      assert Features.get_feature!(feature.id) == feature
    end

    test "create_feature/1 with valid data creates a feature" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Feature{} = feature} = Features.create_feature(valid_attrs)
      assert feature.name == "some name"
      assert feature.description == "some description"
    end

    test "create_feature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Features.create_feature(@invalid_attrs)
    end

    test "update_feature/2 with valid data updates the feature" do
      feature = feature_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Feature{} = feature} = Features.update_feature(feature, update_attrs)
      assert feature.name == "some updated name"
      assert feature.description == "some updated description"
    end

    test "update_feature/2 with invalid data returns error changeset" do
      feature = feature_fixture()
      assert {:error, %Ecto.Changeset{}} = Features.update_feature(feature, @invalid_attrs)
      assert feature == Features.get_feature!(feature.id)
    end

    test "delete_feature/1 deletes the feature" do
      feature = feature_fixture()
      assert {:ok, %Feature{}} = Features.delete_feature(feature)
      assert_raise Ecto.NoResultsError, fn -> Features.get_feature!(feature.id) end
    end

    test "change_feature/1 returns a feature changeset" do
      feature = feature_fixture()
      assert %Ecto.Changeset{} = Features.change_feature(feature)
    end
  end
end
