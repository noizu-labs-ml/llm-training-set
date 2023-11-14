defmodule SyntheticManagerWeb.GrSyntheticGroupLiveTest do
  use SyntheticManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SyntheticManager.SyntheticGroupsFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  defp create_gr_synthetic_group(_) do
    gr_synthetic_group = gr_synthetic_group_fixture()
    %{gr_synthetic_group: gr_synthetic_group}
  end

  describe "Index" do
    setup [:create_gr_synthetic_group]

    test "lists all synthetics/groups", %{conn: conn, gr_synthetic_group: gr_synthetic_group} do
      {:ok, _index_live, html} = live(conn, ~p"/synthetics/groups")

      assert html =~ "Listing Synthetics/groups"
      assert html =~ gr_synthetic_group.name
    end

    test "saves new gr_synthetic_group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/synthetics/groups")

      assert index_live |> element("a", "New Gr synthetic group") |> render_click() =~
               "New Gr synthetic group"

      assert_patch(index_live, ~p"/synthetics/groups/new")

      assert index_live
             |> form("#gr_synthetic_group-form", gr_synthetic_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#gr_synthetic_group-form", gr_synthetic_group: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/synthetics/groups")

      html = render(index_live)
      assert html =~ "Gr synthetic group created successfully"
      assert html =~ "some name"
    end

    test "updates gr_synthetic_group in listing", %{
      conn: conn,
      gr_synthetic_group: gr_synthetic_group
    } do
      {:ok, index_live, _html} = live(conn, ~p"/synthetics/groups")

      assert index_live
             |> element("#synthetics/groups-#{gr_synthetic_group.id} a", "Edit")
             |> render_click() =~
               "Edit Gr synthetic group"

      assert_patch(index_live, ~p"/synthetics/groups/#{gr_synthetic_group}/edit")

      assert index_live
             |> form("#gr_synthetic_group-form", gr_synthetic_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#gr_synthetic_group-form", gr_synthetic_group: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/synthetics/groups")

      html = render(index_live)
      assert html =~ "Gr synthetic group updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes gr_synthetic_group in listing", %{
      conn: conn,
      gr_synthetic_group: gr_synthetic_group
    } do
      {:ok, index_live, _html} = live(conn, ~p"/synthetics/groups")

      assert index_live
             |> element("#synthetics/groups-#{gr_synthetic_group.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#synthetics/groups-#{gr_synthetic_group.id}")
    end
  end

  describe "Show" do
    setup [:create_gr_synthetic_group]

    test "displays gr_synthetic_group", %{conn: conn, gr_synthetic_group: gr_synthetic_group} do
      {:ok, _show_live, html} = live(conn, ~p"/synthetics/groups/#{gr_synthetic_group}")

      assert html =~ "Show Gr synthetic group"
      assert html =~ gr_synthetic_group.name
    end

    test "updates gr_synthetic_group within modal", %{
      conn: conn,
      gr_synthetic_group: gr_synthetic_group
    } do
      {:ok, show_live, _html} = live(conn, ~p"/synthetics/groups/#{gr_synthetic_group}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Gr synthetic group"

      assert_patch(show_live, ~p"/synthetics/groups/#{gr_synthetic_group}/show/edit")

      assert show_live
             |> form("#gr_synthetic_group-form", gr_synthetic_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#gr_synthetic_group-form", gr_synthetic_group: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/synthetics/groups/#{gr_synthetic_group}")

      html = render(show_live)
      assert html =~ "Gr synthetic group updated successfully"
      assert html =~ "some updated name"
    end
  end
end
