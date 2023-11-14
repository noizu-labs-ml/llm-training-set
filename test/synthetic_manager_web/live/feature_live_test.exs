defmodule SyntheticManagerWeb.FeatureLiveTest do
  use SyntheticManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SyntheticManager.FeaturesFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  defp create_feature(_) do
    feature = feature_fixture()
    %{feature: feature}
  end

  describe "Index" do
    setup [:create_feature]

    test "lists all features", %{conn: conn, feature: feature} do
      {:ok, _index_live, html} = live(conn, ~p"/features")

      assert html =~ "Listing Features"
      assert html =~ feature.name
    end

    test "saves new feature", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/features")

      assert index_live |> element("a", "New Feature") |> render_click() =~
               "New Feature"

      assert_patch(index_live, ~p"/features/new")

      assert index_live
             |> form("#feature-form", feature: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#feature-form", feature: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/features")

      html = render(index_live)
      assert html =~ "Feature created successfully"
      assert html =~ "some name"
    end

    test "updates feature in listing", %{conn: conn, feature: feature} do
      {:ok, index_live, _html} = live(conn, ~p"/features")

      assert index_live |> element("#features-#{feature.id} a", "Edit") |> render_click() =~
               "Edit Feature"

      assert_patch(index_live, ~p"/features/#{feature}/edit")

      assert index_live
             |> form("#feature-form", feature: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#feature-form", feature: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/features")

      html = render(index_live)
      assert html =~ "Feature updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes feature in listing", %{conn: conn, feature: feature} do
      {:ok, index_live, _html} = live(conn, ~p"/features")

      assert index_live |> element("#features-#{feature.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#features-#{feature.id}")
    end
  end

  describe "Show" do
    setup [:create_feature]

    test "displays feature", %{conn: conn, feature: feature} do
      {:ok, _show_live, html} = live(conn, ~p"/features/#{feature}")

      assert html =~ "Show Feature"
      assert html =~ feature.name
    end

    test "updates feature within modal", %{conn: conn, feature: feature} do
      {:ok, show_live, _html} = live(conn, ~p"/features/#{feature}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Feature"

      assert_patch(show_live, ~p"/features/#{feature}/show/edit")

      assert show_live
             |> form("#feature-form", feature: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#feature-form", feature: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/features/#{feature}")

      html = render(show_live)
      assert html =~ "Feature updated successfully"
      assert html =~ "some updated name"
    end
  end
end
