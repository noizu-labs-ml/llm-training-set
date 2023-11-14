defmodule SyntheticManagerWeb.FeatureLive.Index do
  use SyntheticManagerWeb, :live_view

  alias SyntheticManager.Features
  alias SyntheticManager.Features.Feature

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :features, Features.list_features())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Feature")
    |> assign(:feature, Features.get_feature!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Feature")
    |> assign(:feature, %Feature{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Features")
    |> assign(:feature, nil)
  end

  @impl true
  def handle_info({SyntheticManagerWeb.FeatureLive.FormComponent, {:saved, feature}}, socket) do
    {:noreply, stream_insert(socket, :features, feature)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    feature = Features.get_feature!(id)
    {:ok, _} = Features.delete_feature(feature)

    {:noreply, stream_delete(socket, :features, feature)}
  end
end
