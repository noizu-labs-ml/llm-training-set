defmodule SyntheticManagerWeb.SyntheticLive.Index do
  use SyntheticManagerWeb, :live_view

  alias SyntheticManager.Synthetics
  alias SyntheticManager.Synthetics.Synthetic
  alias SyntheticManager.Features

  @impl true
  def mount(_params, _session, socket) do
    feature_options = Features.list_features()
                      |> Enum.map(& [key: &1.name, value: "#{&1.id}"])

    socket = socket
             |> assign(:feature_options, feature_options)
    {:ok, stream(socket, :synthetics, Synthetics.list_synthetics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    feature_options = Features.list_features()
                      |> Enum.map(& [key: &1.name, value: "#{&1.id}"])

    socket
    |> assign(:page_title, "Edit Synthetic")
    |> assign(:synthetic, Synthetics.get_synthetic!(id, :hydrate) |> IO.inspect(label: "HERE"))
    |> assign(:feature_options, feature_options)
  end

  defp apply_action(socket, :new, _params) do
    feature_options = Features.list_features()
                      |> Enum.map(& [key: &1.name, value: "#{&1.id}"])

    socket
    |> assign(:page_title, "New Synthetic")
    |> assign(:synthetic, %Synthetic{})
    |> assign(:feature_options, feature_options)
  end

  defp apply_action(socket, :index, _params) do
    feature_options = Features.list_features()
                      |> Enum.map(& [key: &1.name, value: "#{&1.id}"])

    socket
    |> assign(:page_title, "Listing Synthetics")
    |> assign(:synthetic, nil)
    |> assign(:feature_options, feature_options)
  end

  @impl true
  def handle_info({SyntheticManagerWeb.SyntheticLive.FormComponent, {:saved, synthetic}}, socket) do
    {:noreply, stream_insert(socket, :synthetics, synthetic)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    synthetic = Synthetics.get_synthetic!(id, :hydrate)
    {:ok, _} = Synthetics.delete_synthetic(synthetic)

    {:noreply, stream_delete(socket, :synthetics, synthetic)}
  end
end
