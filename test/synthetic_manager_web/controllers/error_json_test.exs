defmodule SyntheticManagerWeb.ErrorJSONTest do
  use SyntheticManagerWeb.ConnCase, async: true

  test "renders 404" do
    assert SyntheticManagerWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert SyntheticManagerWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
