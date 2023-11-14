defmodule SyntheticManager.SyntheticGroupsTest do
  use SyntheticManager.DataCase

  alias SyntheticManager.SyntheticGroups

  describe "synthetics/groups" do
    alias SyntheticManager.SyntheticGroups.GrSyntheticGroup

    import SyntheticManager.SyntheticGroupsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_synthetics/groups/0 returns all synthetics/groups" do
      gr_synthetic_group = gr_synthetic_group_fixture()
      assert SyntheticGroups.list_synthetics() / groups() == [gr_synthetic_group]
    end

    test "get_gr_synthetic_group!/1 returns the gr_synthetic_group with given id" do
      gr_synthetic_group = gr_synthetic_group_fixture()
      assert SyntheticGroups.get_gr_synthetic_group!(gr_synthetic_group.id) == gr_synthetic_group
    end

    test "create_gr_synthetic_group/1 with valid data creates a gr_synthetic_group" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %GrSyntheticGroup{} = gr_synthetic_group} =
               SyntheticGroups.create_gr_synthetic_group(valid_attrs)

      assert gr_synthetic_group.name == "some name"
      assert gr_synthetic_group.description == "some description"
    end

    test "create_gr_synthetic_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               SyntheticGroups.create_gr_synthetic_group(@invalid_attrs)
    end

    test "update_gr_synthetic_group/2 with valid data updates the gr_synthetic_group" do
      gr_synthetic_group = gr_synthetic_group_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %GrSyntheticGroup{} = gr_synthetic_group} =
               SyntheticGroups.update_gr_synthetic_group(gr_synthetic_group, update_attrs)

      assert gr_synthetic_group.name == "some updated name"
      assert gr_synthetic_group.description == "some updated description"
    end

    test "update_gr_synthetic_group/2 with invalid data returns error changeset" do
      gr_synthetic_group = gr_synthetic_group_fixture()

      assert {:error, %Ecto.Changeset{}} =
               SyntheticGroups.update_gr_synthetic_group(gr_synthetic_group, @invalid_attrs)

      assert gr_synthetic_group == SyntheticGroups.get_gr_synthetic_group!(gr_synthetic_group.id)
    end

    test "delete_gr_synthetic_group/1 deletes the gr_synthetic_group" do
      gr_synthetic_group = gr_synthetic_group_fixture()

      assert {:ok, %GrSyntheticGroup{}} =
               SyntheticGroups.delete_gr_synthetic_group(gr_synthetic_group)

      assert_raise Ecto.NoResultsError, fn ->
        SyntheticGroups.get_gr_synthetic_group!(gr_synthetic_group.id)
      end
    end

    test "change_gr_synthetic_group/1 returns a gr_synthetic_group changeset" do
      gr_synthetic_group = gr_synthetic_group_fixture()
      assert %Ecto.Changeset{} = SyntheticGroups.change_gr_synthetic_group(gr_synthetic_group)
    end
  end
end
