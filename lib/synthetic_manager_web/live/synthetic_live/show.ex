defmodule SyntheticManagerWeb.SyntheticLive.Show do
  use SyntheticManagerWeb, :live_view

  alias SyntheticManager.Synthetics
  alias SyntheticManager.Features

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
             |> assign(:features, Features.list_features())
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    synthetic = Synthetics.get_synthetic!(id, :hydrate)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:synthetic, synthetic)
     |> assign(:features, Features.list_features())
    }
  end

  defp page_title(:show), do: "Show Synthetic"
  defp page_title(:edit), do: "Edit Synthetic"
end
