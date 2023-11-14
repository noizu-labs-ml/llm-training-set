defmodule SyntheticManagerWeb.SyntheticLive.Show do
  use SyntheticManagerWeb, :live_view

  alias SyntheticManager.Synthetics
  alias SyntheticManager.Features

  @impl true
  def mount(_params, _session, socket) do
    feature_options = Features.list_features()
                      |> Enum.map(& [key: &1.name, value: "#{&1.id}"])

    socket = socket
             |> assign(:feature_options, feature_options)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    synthetic = Synthetics.get_synthetic!(id, :hydrate)
    feature_options = Features.list_features()
                      |> Enum.map(& [key: &1.name, value: "#{&1.id}"])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:synthetic, synthetic)
     |> assign(:feature_options, feature_options)

    }
  end

  defp page_title(:show), do: "Show Synthetic"
  defp page_title(:edit), do: "Edit Synthetic"
end
